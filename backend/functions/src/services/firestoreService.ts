import * as admin from "firebase-admin";
import { ReportInsightShape, RawParameter } from "../utils/responseShaper";

const db = () => admin.firestore();

// ─── Types ────────────────────────────────────────────────────────────────────

export interface SavedReport extends ReportInsightShape {
  reportId: string;
  userId: string;
  createdAt: admin.firestore.Timestamp;
}

// ─── Save a newly analyzed report ────────────────────────────────────────────

export const saveReport = async (
  userId: string,
  data: ReportInsightShape
): Promise<string> => {
  const reportRef = db().collection("reports").doc();

  await reportRef.set({
    ...data,
    userId,
    reportId: reportRef.id,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return reportRef.id;
};

// ─── Fetch user's past reports (summary list) ─────────────────────────────────

export const getUserReports = async (userId: string): Promise<SavedReport[]> => {
  const snapshot = await db()
    .collection("reports")
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .limit(50)
    .get();

  return snapshot.docs.map((doc) => doc.data() as SavedReport);
};

// ─── Build timeline data from stored reports ──────────────────────────────────
/**
 * Aggregates rawParameters across all of a user's reports into a
 * Map<metricName, TimelineModel> that matches the Flutter TimelineModel contract.
 */
export const getTimelineData = async (
  userId: string
): Promise<Record<string, any>> => {
  const reports = await getUserReports(userId);

  // Sort oldest → newest so chart x-axis is chronological
  const sorted = [...reports].sort(
    (a, b) => a.createdAt?.seconds - b.createdAt?.seconds
  );

  // metric name → { unit, dataPoints[], history[] }
  const metricMap: Record<
    string,
    {
      metricName: string;
      unit: string;
      dataPoints: { x: number; y: number; label: string }[];
      history: {
        date: string;
        title: string;
        changeText: string;
        isImprovement: boolean;
      }[];
    }
  > = {};

  sorted.forEach((report, reportIndex) => {
    const params: RawParameter[] = report.rawParameters ?? [];
    const label = _monthLabel(report.createdAt);

    params.forEach((param) => {
      const numericValue = _extractNumeric(param.value);
      if (numericValue === null) return; // skip non-numeric params

      const unit = _extractUnit(param.value);
      const name = param.parameter;

      if (!metricMap[name]) {
        metricMap[name] = {
          metricName: name,
          unit,
          dataPoints: [],
          history: [],
        };
      }

      const entry = metricMap[name];

      // DataPoint for the chart
      entry.dataPoints.push({
        x: reportIndex,
        y: numericValue,
        label,
      });

      // History row
      const prev = entry.dataPoints[entry.dataPoints.length - 2];
      let changeText = "";
      let isImprovement = false;

      if (prev) {
        const delta = numericValue - prev.y;
        changeText = `${delta >= 0 ? "+" : ""}${delta.toFixed(1)} ${unit}`;
        // "improvement" = value moved toward normal; approximate via direction of change
        isImprovement = param.status === "High" ? delta < 0 : delta > 0;
      }

      if (reportIndex > 0) {
        entry.history.push({
          date: report.date,
          title: report.reportTitle,
          changeText: changeText || param.value,
          isImprovement,
        });
      }
    });
  });

  return metricMap;
};

// ─── Private helpers ──────────────────────────────────────────────────────────

const _extractNumeric = (value: string): number | null => {
  const match = value.match(/[\d.]+/);
  return match ? parseFloat(match[0]) : null;
};

const _extractUnit = (value: string): string => {
  const match = value.match(/[a-zA-Z/%]+/);
  return match ? match[0] : "";
};

const _monthLabel = (ts?: admin.firestore.Timestamp): string => {
  if (!ts) return "?";
  const d = ts.toDate();
  return d.toLocaleDateString("en-US", { month: "short" });
};
