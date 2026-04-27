/**
 * Cleans and parses a JSON string from Gemini output.
 *
 * Handles:
 *  - Markdown code fences (```json ... ```)
 *  - Prose before/after the JSON object
 *  - Trailing commas (best-effort)
 */
export const cleanAndParseJSON = (raw: string): any => {
  try {
    // Strip markdown code fences
    let cleaned = raw
      .replace(/```json\s*/gi, "")
      .replace(/```\s*/g, "")
      .trim();

    // If there's prose before the JSON object, extract just the object
    const objectStart = cleaned.indexOf("{");
    const objectEnd = cleaned.lastIndexOf("}");
    if (objectStart !== -1 && objectEnd !== -1 && objectEnd > objectStart) {
      cleaned = cleaned.slice(objectStart, objectEnd + 1);
    }

    return JSON.parse(cleaned);
  } catch (err) {
    console.error("[cleanAndParseJSON] Parse error:", err);
    console.error("[cleanAndParseJSON] Raw input:", raw.slice(0, 500));
    return {
      error: "Invalid AI response format",
      raw_output: raw,
    };
  }
};