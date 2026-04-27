import path from "path";
import { analyzeReportWithGemini } from "./geminiService";
import { cleanAndParseJSON } from "../utils/cleanJson";
import { shapeResponse, ReportInsightShape } from "../utils/responseShaper";

const SUPPORTED_EXTENSIONS = [".pdf", ".png", ".jpg", ".jpeg"];

/**
 * Orchestrates the full report-processing pipeline:
 *   1. Validate file type
 *   2. Send directly to Gemini (PDF-native — no conversion needed)
 *   3. Clean & parse JSON output
 *   4. Shape into ReportInsightModel contract
 */
export const processReport = async (
  filePath: string
): Promise<ReportInsightShape> => {
  const ext = path.extname(filePath).toLowerCase();

  if (!SUPPORTED_EXTENSIONS.includes(ext)) {
    throw new Error(
      `Unsupported file type: "${ext}". Accepted formats: PDF, PNG, JPG.`
    );
  }

  // Gemini 2.5 Flash natively understands PDFs and images — no pre-processing.
  const rawText = await analyzeReportWithGemini(filePath);
  const parsed = cleanAndParseJSON(rawText);

  if (parsed?.error) {
    throw new Error(`AI response could not be parsed: ${parsed.error}`);
  }

  return shapeResponse(parsed);
};