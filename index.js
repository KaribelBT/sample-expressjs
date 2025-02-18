require("dotenv").config();
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const { MongoClient, ObjectId } = require("mongodb");
const winston = require("winston");
const { format } = require("logform");
const { v4: uuidv4 } = require("uuid");

const host = process.env.MONGODB_HOST;
const username = process.env.MONGODB_USERNAME;
const password = process.env.MONGODB_PASSWORD;
const dbName = process.env.DB_NAME;
const collection_name = process.env.COLLECTION_NAME;

const url = `mongodb+srv://${username}:${password}@${host}`;

// Configure winston logger
const logger = winston.createLogger({
  level: "info",
  format: format.combine(
    format.timestamp(),
    format.printf(({ timestamp, level, message, executionId }) => {
      return JSON.stringify({ timestamp, level, executionId, message });
    })
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: "combined.log" }),
  ],
});

// Middleware to generate and attach execution ID to each request
app.use((req, res, next) => {
  req.executionId = uuidv4();
  logger.info({
    executionId: req.executionId,
    message: `${req.method} ${req.url}`,
  });
  next();
});

let db;

(async () => {
  try {
    const client = await MongoClient.connect(url);
    const executionId = req.executionId;
    logger.info({ executionId: executionId, message: "Connected to Database" });
    db = client.db(dbName);
  } catch (error) {
    logger.error({
      executionId: executionId,
      message: `Database connection error: ${error}`,
    });
  }
})();

app.get("/", (req, res) => res.send("Hello World!"));

app.listen(port, () =>
  console.log(`sample-expressjs app listening on port ${port}!`)
);
