import { Request, Response } from "express";
import fs from "fs";
import { processReport } from "../services/extractionService";
import { saveReport } from "../services/firestoreService";

/**
 * POST /analyze-report
 *
 * Accepts a multipart/form-data upload with a "file" field (PDF or image).
 * Requires a valid Firebase Auth token (set by verifyAuth middleware).
 *
 * 1. Validates file presence and userId
 * 2. Runs the AI analysis pipeline
 * 3. Saves the result to Firestore under the user's account
 * 4. Cleans up the temp file
 * 5. Returns the ReportInsightModel + reportId
 */
export const analyzeReportHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  const filePath = req.file?.path;

  try {
    if (!req.file || !filePath) {
      res.status(400).json({
        error: "File is required. Send a PDF or image using the field name 'file'.",
      });
      return;
    }

    const userId = req.userId;
    if (!userId) {
      res.status(401).json({ error: "Unauthorized." });
      return;
    }

    // ── AI Analysis ──────────────────────────────────────────────────────────
    const result = await processReport(filePath);

    // ── Persist to Firestore ──────────────────────────────────────────────────
    const reportId = await saveReport(userId, result);

    // ── Cleanup temp file ─────────────────────────────────────────────────────
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

    // ── Respond ───────────────────────────────────────────────────────────────
    res.status(200).json({ reportId, ...result });
  } catch (error: unknown) {
    // Best-effort cleanup even on error
    if (filePath && fs.existsSync(filePath)) {
      try {
        fs.unlinkSync(filePath);
      } catch { /* ignore cleanup errors */ }
    }

    const message =
      error instanceof Error ? error.message : "Internal server error.";
    console.error("[analyzeReport] ERROR:", error);
    res.status(500).json({ error: message });
  }
};