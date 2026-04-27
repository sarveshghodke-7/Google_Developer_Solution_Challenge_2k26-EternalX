import { VertexAI } from "@google-cloud/vertexai";
import fs from "fs";
import path from "path";

// ─── Vertex AI Client ────────────────────────────────────────────────────────
// Project ID is read from the environment variable GCLOUD_PROJECT so this
// works both locally (via Application Default Credentials) and on Firebase
// Functions (which sets GCLOUD_PROJECT automatically).
const vertexAI = new VertexAI({
  project: process.env.GCLOUD_PROJECT ?? "healthlens-5fc36",
  location: "us-central1",
});

const model = vertexAI.getGenerativeModel({
  model: "gemini-2.5-flash",
  generationConfig: {
    responseMimeType: "application/json",
  },
});

// ─── Prompt ──────────────────────────────────────────────────────────────────
const ANALYSIS_PROMPT = `You are a compassionate medical AI assistant. Analyze this medical lab report carefully.
Return ONLY valid JSON — no markdown, no code fences, no extra text.

REQUIRED FORMAT:
{
  "reportTitle": "Name of the test (e.g. 'Lipid Panel', 'Complete Blood Count', 'Thyroid Profile')",
  "date": "Date of the report formatted as 'Month DD, YYYY' (extract from the report if present, else use today)",
  "explanation": "2-4 sentence plain-language explanation of what this overall report means. Write for someone with no medical background. Be reassuring but honest.",
  "alerts": [
    {
      "title": "Short alert heading (e.g. 'High LDL Cholesterol')",
      "message": "One sentence: what the value is and why it matters. Include the actual value.",
      "isWarning": true
    }
  ],
  "actions": [
    {
      "title": "Short action title (e.g. 'Reduce Saturated Fats')",
      "description": "One practical sentence the user can act on immediately."
    }
  ],
  "rawParameters": [
    {
      "parameter": "Parameter name exactly as on the report",
      "value": "Value with unit (e.g. '160 mg/dL')",
      "status": "Normal | High | Low | Critical | Borderline",
      "referenceRange": "Normal range from the report (e.g. '< 100 mg/dL')"
    }
  ]
}

Rules:
- alerts: ONLY include parameters that are outside normal range. isWarning=true for High/Low, false for borderline-informational.
- If all values are normal, return an empty alerts array and a positive explanation.
- actions: provide 2-4 concrete, specific, actionable steps. Tailor them to the specific abnormal findings.
- rawParameters: include ALL parameters found in the report regardless of their status.
- NEVER include any text outside the JSON object.`;

// ─── Helper: determine MIME type from extension ───────────────────────────────
const getMimeType = (
  filePath: string
): "application/pdf" | "image/png" | "image/jpeg" => {
  const ext = path.extname(filePath).toLowerCase();
  if (ext === ".pdf") return "application/pdf";
  if (ext === ".png") return "image/png";
  return "image/jpeg"; // .jpg / .jpeg
};

// ─── Main export ─────────────────────────────────────────────────────────────
/**
 * Sends a medical report file (PDF or image) directly to Gemini for analysis.
 * Returns the raw JSON string from Gemini.
 *
 * No pre-processing required — Gemini 2.5 Flash natively understands PDFs.
 */
export const analyzeReportWithGemini = async (
  filePath: string
): Promise<string> => {
  const mimeType = getMimeType(filePath);
  const base64Data = fs.readFileSync(filePath, { encoding: "base64" });

  const result = await model.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          { text: ANALYSIS_PROMPT },
          {
            inlineData: {
              mimeType,
              data: base64Data,
            },
          },
        ],
      },
    ],
  });

  const textOutput =
    result.response.candidates?.[0]?.content?.parts?.[0]?.text;

  if (!textOutput) {
    throw new Error("Gemini returned an empty response. Please try again.");
  }

  return textOutput;
};