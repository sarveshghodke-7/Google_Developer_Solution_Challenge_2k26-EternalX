import { Request, Response } from "express";
import { getUserReports } from "../services/firestoreService";

/**
 * GET /reports
 *
 * Returns the authenticated user's past analyzed reports, ordered newest first.
 * Each item is a summary suitable for displaying in a list (no rawParameters).
 */
export const getReportsHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const userId = req.userId!;
    const reports = await getUserReports(userId);

    // Strip rawParameters from the list view — they're large and not needed here
    const summaries = reports.map(({ rawParameters, ...rest }) => rest);

    res.status(200).json({ reports: summaries });
  } catch (error: unknown) {
    const message =
      error instanceof Error ? error.message : "Internal server error.";
    console.error("[getReports] ERROR:", error);
    res.status(500).json({ error: message });
  }
};
