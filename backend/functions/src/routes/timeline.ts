import { Request, Response } from "express";
import { getTimelineData } from "../services/firestoreService";

/**
 * GET /timeline
 *
 * Derives a Map<metricName, TimelineModel> from all of the authenticated
 * user's stored reports. This feeds directly into the Flutter TimelineScreen.
 *
 * If the user has fewer than 2 reports, returns an empty object — the Flutter
 * screen should show a "Upload more reports to see trends" empty state.
 */
export const getTimelineHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const userId = req.userId!;
    const timelineData = await getTimelineData(userId);

    res.status(200).json(timelineData);
  } catch (error: unknown) {
    const message =
      error instanceof Error ? error.message : "Internal server error.";
    console.error("[getTimeline] ERROR:", error);
    res.status(500).json({ error: message });
  }
};
