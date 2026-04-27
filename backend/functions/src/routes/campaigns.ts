import { Request, Response } from "express";
import {
  getCampaignsForUser,
  joinCampaign,
} from "../services/campaignService";

/**
 * GET /campaigns
 *
 * Returns the authenticated user's:
 *   - Active campaigns (ones they've joined, with progress)
 *   - Recommended campaigns (based on latest report's abnormal parameters)
 *   - All other available campaigns
 *
 * The Flutter CampaignsScreen reads `isActive` to split into sections.
 */
export const getCampaignsHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const userId = req.userId!;
    const result = await getCampaignsForUser(userId);
    res.status(200).json(result);
  } catch (error: unknown) {
    const message =
      error instanceof Error ? error.message : "Internal server error.";
    console.error("[getCampaigns] ERROR:", error);
    res.status(500).json({ error: message });
  }
};

/**
 * POST /campaigns/:campaignId/join
 *
 * Marks the specified campaign as active for the authenticated user.
 */
export const joinCampaignHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const userId = req.userId!;
    const { campaignId } = req.params;

    if (!campaignId) {
      res.status(400).json({ error: "campaignId is required." });
      return;
    }

    await joinCampaign(userId, campaignId);
    res.status(200).json({ success: true, daysCompleted: 0 });
  } catch (error: unknown) {
    const message =
      error instanceof Error ? error.message : "Internal server error.";
    console.error("[joinCampaign] ERROR:", error);
    res.status(500).json({ error: message });
  }
};
