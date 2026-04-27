import fs from "fs";
import path from "path";
import { exec } from "child_process";

export const convertPdfToImages = (pdfPath: string): Promise<string[]> => {
  return new Promise((resolve, reject) => {
    const outputDir = path.join(__dirname, "../../tmp");

    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir);
    }

    const command = `"D:\\Poppler\\poppler-25.12.0\\Library\\bin\\pdftoppm.exe" -png ${pdfPath} ${outputDir}/page`;
    exec(command, (error) => {
      if (error) return reject(error);

      const files = fs.readdirSync(outputDir)
        .filter(f => f.endsWith(".png"))
        .map(f => path.join(outputDir, f));

      resolve(files);
    });
  });
};