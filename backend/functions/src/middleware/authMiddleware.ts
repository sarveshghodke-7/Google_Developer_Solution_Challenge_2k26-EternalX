import { Request, Response, NextFunction } from "express";
import * as admin from "firebase-admin";

// Extend Express Request to carry userId downstream
declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      userId?: string;
    }
  }
}

/**
 * Verifies the Firebase ID token sent in the Authorization header.
 * Attaches req.userId on success.
 *
 * Clients must send: Authorization: Bearer <firebase-id-token>
 */
export const verifyAuth = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ error: "Unauthorized: missing Bearer token." });
    return;
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.userId = decodedToken.uid;
    next();
  } catch (error) {
    console.error("Auth token verification failed:", error);
    res.status(401).json({ error: "Unauthorized: invalid or expired token." });
  }
};
