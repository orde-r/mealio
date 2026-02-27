import express from "express";
import { Response, Request } from "express";
import { PrismaClient } from "@prisma/client";

import { authRouter } from "./routes/authRoute";

const app = express();
const prisma = new PrismaClient();
const port = 3000;

app.use(express.json());

app.use("/api/auth", authRouter);
app.get("/api/health", async (req: Request, res: Response) => {
  try {
    await prisma.$queryRaw`SELECT 1`;

    res.status(200).json({
      success: true,
      message: `Mealio Server is up and Database is connected`,
    });
  } catch (error) {
    console.error(`Failed to connect database:`, error);
    res.status(500).json({
      success: false,
      message: "Database Connection Failed",
    });
  }
});

app.listen(port, () => {
  console.log(`App Listening on port ${3000}`);
});
