import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import express from "express";
import cors from "cors";
import multer from "multer";
import path from "path";
import fs from "fs";

import { verifyAuth } from "./middleware/authMiddleware";
import { analyzeReportHandler } from "./routes/analyzeReport";
import { getReportsHandler } from "./routes/reports";
import { getTimelineHandler } from "./routes/timeline";
import { getCampaignsHandler, joinCampaignHandler } from "./routes/campaigns";
import { seedCampaigns } from "./services/campaignService";

// ─── Firebase Admin SDK ───────────────────────────────────────────────────────
// Uses Application Default Credentials (ADC):
//   - On Firebase Functions: automatically authenticated as the service account
//   - Locally: `gcloud auth application-default login` or GOOGLE_APPLICATION_CREDENTIALS env var
if (!admin.apps.length) {
  admin.initializeApp();
}

// Seed the campaigns catalog on cold start (no-op if already seeded)
seedCampaigns().catch((err) =>
  console.error("[seedCampaigns] Failed to seed campaigns:", err)
);

// ─── Express App ─────────────────────────────────────────────────────────────
const app = express();

// ─── CORS ─────────────────────────────────────────────────────────────────────
// Allow Flutter mobile app (any origin) and restrict if deploying web.
// For production, replace with specific domains.
const allowedOrigins = [
  "http://localhost:3000",
  "http://localhost:4200",
  // Add your deployed Flutter Web / Web app domain here
];

app.use(
  cors({
    origin: (origin, callback) => {
      // Allow mobile clients (no origin header) and allowed web origins
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error(`CORS: origin '${origin}' not allowed.`));
      }
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

// ─── Uploads Directory ────────────────────────────────────────────────────────
const uploadDir = path.join(__dirname, "../uploads");
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// ─── Multer (file upload) ─────────────────────────────────────────────────────
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) =>
    cb(null, `${Date.now()}${path.extname(file.originalname)}`),
});

const upload = multer({
  storage,
  limits: { fileSize: 25 * 1024 * 1024 }, // 25 MB
  fileFilter: (_req, file, cb) => {
    const allowed = [
      "application/pdf",
      "image/png",
      "image/jpeg",
      "image/jpg",
    ];
    if (allowed.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error("Only PDF, PNG, and JPG files are accepted."));
    }
  },
});

// ─── Health Check (public) ────────────────────────────────────────────────────
app.get("/", (_req, res) => {
  res.json({ status: "ok", message: "MediCore API is running 🚀" });
});

// ─── Protected Routes ─────────────────────────────────────────────────────────
// All routes below this point require a valid Firebase ID token.

// Report Analysis — multer MUST be before verifyAuth for multipart parsing
app.post(
  "/analyze-report",
  upload.single("file"),
  verifyAuth,
  analyzeReportHandler
);

// Past reports
app.get("/reports", verifyAuth, getReportsHandler);

// Health timeline
app.get("/timeline", verifyAuth, getTimelineHandler);

// Campaigns
app.get("/campaigns", verifyAuth, getCampaignsHandler);
app.post("/campaigns/:campaignId/join", verifyAuth, joinCampaignHandler);

// JSON parsing for non-file routes (must come AFTER multer routes)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ─── Firebase Cloud Function Export ──────────────────────────────────────────
export const api = functions.https.onRequest(
  {
    timeoutSeconds: 540,
    memory: "1GiB",
    // Ensure the function region matches your Firestore region
    region: "us-central1",
  },
  app
);

// ─── Local Development Server ─────────────────────────────────────────────────
// Only starts when running locally (not in Firebase emulator or cloud)
if (require.main === module) {
  const PORT = process.env.PORT ?? 5000;
  app.listen(PORT, () => {
    console.log(`✅ MediCore API running at http://localhost:${PORT}`);
    console.log("   POST  /analyze-report");
    console.log("   GET   /reports");
    console.log("   GET   /timeline");
    console.log("   GET   /campaigns");
    console.log("   POST  /campaigns/:id/join");
  });
}