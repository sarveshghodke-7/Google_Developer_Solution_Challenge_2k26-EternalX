/**
 * Validates and normalizes the raw Gemini JSON output into
 * the exact ReportInsightModel shape the Flutter frontend expects.
 *
 * Also preserves rawParameters for Firestore-based timeline tracking.
 */

export interface AlertShape {
  title: string;
  message: string;
  isWarning: boolean;
}

export interface ActionShape {
  title: string;
  description: string;
}

export interface RawParameter {
  parameter: string;
  value: string;
  status: string;
  referenceRange?: string;
}

export interface ReportInsightShape {
  reportTitle: string;
  date: string;
  explanation: string;
  alerts: AlertShape[];
  actions: ActionShape[];
  rawParameters: RawParameter[];
}

export const shapeResponse = (raw: any): ReportInsightShape => {
  const today = new Date().toLocaleDateString("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const reportTitle =
    typeof raw?.reportTitle === "string" && raw.reportTitle.trim()
      ? raw.reportTitle.trim()
      : "Medical Lab Report";

  const date =
    typeof raw?.date === "string" && raw.date.trim()
      ? raw.date.trim()
      : today;

  const explanation =
    typeof raw?.explanation === "string" && raw.explanation.trim()
      ? raw.explanation.trim()
      : "Your report has been analyzed. Please consult your doctor for a detailed interpretation.";

  const alerts: AlertShape[] = Array.isArray(raw?.alerts)
    ? raw.alerts
        .filter((a: any) => a && typeof a.title === "string")
        .map((a: any) => ({
          title: a.title ?? "Alert",
          message: a.message ?? "",
          isWarning: typeof a.isWarning === "boolean" ? a.isWarning : true,
        }))
    : [];

  const actions: ActionShape[] = Array.isArray(raw?.actions)
    ? raw.actions
        .filter((a: any) => a && typeof a.title === "string")
        .map((a: any) => ({
          title: a.title ?? "Action",
          description: a.description ?? "",
        }))
    : [];

  const rawParameters: RawParameter[] = Array.isArray(raw?.rawParameters)
    ? raw.rawParameters
        .filter((p: any) => p && typeof p.parameter === "string")
        .map((p: any) => ({
          parameter: p.parameter ?? "Unknown",
          value: p.value ?? "",
          status: p.status ?? "Unknown",
          referenceRange: p.referenceRange ?? "",
        }))
    : [];

  return {
    reportTitle,
    date,
    explanation,
    alerts,
    actions,
    rawParameters,
  };
};
