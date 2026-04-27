import * as admin from "firebase-admin";
import { getUserReports } from "./firestoreService";

const db = () => admin.firestore();

// ─── Campaign catalog seed (called once from index.ts on cold start) ──────────

export interface Campaign {
  campaignId: string;
  title: string;
  description: string;
  daysTotal: number;
  category: "Diet" | "Exercise" | "Lifestyle" | "General";
  relatedParameters: string[]; // parameter names that trigger this recommendation
}

const CAMPAIGN_CATALOG: Omit<Campaign, "campaignId">[] = [
  {
    title: "7-Day No Sugar Challenge",
    description:
      "Cut out all processed sugars for 7 days to help regulate your glucose and insulin levels.",
    daysTotal: 7,
    category: "Diet",
    relatedParameters: ["Fasting Glucose", "HbA1c", "Blood Sugar", "Glucose"],
  },
  {
    title: "Daily Step Goal",
    description:
      "Walk 8,000 steps a day to improve cardiovascular health, lower LDL, and boost HDL cholesterol.",
    daysTotal: 30,
    category: "Exercise",
    relatedParameters: [
      "LDL Cholesterol",
      "Total Cholesterol",
      "HDL Cholesterol",
      "Triglycerides",
    ],
  },
  {
    title: "Heart-Healthy Diet",
    description:
      "Follow a Mediterranean-style diet for 30 days — rich in vegetables, whole grains, and healthy fats.",
    daysTotal: 30,
    category: "Diet",
    relatedParameters: [
      "LDL Cholesterol",
      "Total Cholesterol",
      "Triglycerides",
      "VLDL",
    ],
  },
  {
    title: "Iron-Rich Foods Week",
    description:
      "Focus on iron-rich foods like lentils, spinach, and lean meat to boost your hemoglobin levels.",
    daysTotal: 7,
    category: "Diet",
    relatedParameters: ["Hemoglobin", "Hematocrit", "RBC", "Iron", "Ferritin"],
  },
  {
    title: "Hydration Challenge",
    description:
      "Drink 8 glasses of water daily for 14 days to support kidney function and overall health.",
    daysTotal: 14,
    category: "Lifestyle",
    relatedParameters: [
      "Creatinine",
      "BUN",
      "Uric Acid",
      "Kidney Function",
      "eGFR",
    ],
  },
  {
    title: "Mindful Sleep Reset",
    description:
      "Establish a consistent sleep schedule for 14 days to improve cortisol regulation and thyroid function.",
    daysTotal: 14,
    category: "Lifestyle",
    relatedParameters: ["TSH", "Cortisol", "Thyroid", "T3", "T4"],
  },
  {
    title: "30-Minute Daily Workout",
    description:
      "Commit to 30 minutes of moderate exercise each day for 21 days to improve metabolic markers.",
    daysTotal: 21,
    category: "Exercise",
    relatedParameters: [
      "Blood Sugar",
      "Fasting Glucose",
      "Insulin",
      "Triglycerides",
    ],
  },
];

/**
 * Seeds the campaigns catalog into Firestore if it doesn't exist.
 * Safe to call on every cold start — uses set() with no overwrite if doc exists.
 */
export const seedCampaigns = async (): Promise<void> => {
  const batch = db().batch();
  const col = db().collection("campaigns");

  for (const campaign of CAMPAIGN_CATALOG) {
    // Use a stable deterministic ID from the title
    const id = campaign.title.replace(/\s+/g, "_").toLowerCase();
    const ref = col.doc(id);
    const snap = await ref.get();
    if (!snap.exists) {
      batch.set(ref, { campaignId: id, ...campaign });
    }
  }

  await batch.commit();
};

/**
 * Returns the user's campaigns: active ones they've joined + recommended ones
 * based on their latest report's rawParameters.
 */
export const getCampaignsForUser = async (
  userId: string
): Promise<{
  campaigns: (Campaign & {
    daysCompleted: number;
    isActive: boolean;
  })[];
}> => {
  // ── 1. Fetch all campaigns from Firestore catalog ─────────────────────────
  const catalogSnap = await db().collection("campaigns").get();
  const catalog = catalogSnap.docs.map((d) => d.data() as Campaign);

  // ── 2. Fetch user's joined campaigns ─────────────────────────────────────
  const joinedSnap = await db()
    .collection("userCampaigns")
    .where("userId", "==", userId)
    .get();

  const joinedMap = new Map<
    string,
    { daysCompleted: number; isActive: boolean }
  >();
  joinedSnap.docs.forEach((d) => {
    const data = d.data();
    joinedMap.set(data.campaignId, {
      daysCompleted: data.daysCompleted ?? 0,
      isActive: data.isActive ?? false,
    });
  });

  // ── 3. Get latest report's abnormal parameters ────────────────────────────
  const reports = await getUserReports(userId);
  const latestReport = reports[0]; // already sorted newest-first
  const abnormalParams = new Set<string>(
    (latestReport?.rawParameters ?? [])
      .filter((p) => p.status !== "Normal")
      .map((p) => p.parameter.toLowerCase())
  );

  // ── 4. Build response ──────────────────────────────────────────────────────
  const result = catalog.map((campaign) => {
    const joined = joinedMap.get(campaign.campaignId);

    const isRecommended =
      !joined &&
      campaign.relatedParameters.some((param) =>
        abnormalParams.has(param.toLowerCase())
      );

    return {
      ...campaign,
      daysCompleted: joined?.daysCompleted ?? 0,
      isActive: joined?.isActive ?? false,
      isRecommended,
    };
  });

  // Active campaigns first, then recommended, then the rest
  result.sort((a, b) => {
    if (a.isActive && !b.isActive) return -1;
    if (!a.isActive && b.isActive) return 1;
    if ((a as any).isRecommended && !(b as any).isRecommended) return -1;
    if (!(a as any).isRecommended && (b as any).isRecommended) return 1;
    return 0;
  });

  return { campaigns: result };
};

/**
 * Marks a campaign as active (joined) for a user.
 */
export const joinCampaign = async (
  userId: string,
  campaignId: string
): Promise<void> => {
  const docId = `${userId}_${campaignId}`;
  await db()
    .collection("userCampaigns")
    .doc(docId)
    .set(
      {
        userId,
        campaignId,
        daysCompleted: 0,
        isActive: true,
        startedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
};
