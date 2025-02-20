require("dotenv").config();
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const { MongoClient, ObjectId } = require("mongodb");
const winston = require("winston");
const { format } = require("logform");
const { v4: uuidv4 } = require("uuid");

const connection_string = process.env.MONGODB_CONNECTION_STRING;
const collection_name = process.env.MONGODB_COLLECTION_NAME;

console.log(connection_string);
console.log(collection_name);

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

app.post("/docs", async (req, res) => {
  const executionId = req.executionId;
  logger.info({ executionId, message: "POST /docs - Add a document" });
  try {
    const document = req.body;
    logger.info({
      executionId,
      message: `Document to add: ${JSON.stringify(document)}`,
    });
    let db;
    try {
      const client = await MongoClient.connect(connection_string);
      logger.info({ executionId, message: "Connected to Database" });
      db = client.db(dbName);
    } catch (error) {
      logger.error({
        executionId,
        message: `Database connection error: ${error}`,
      });
    }
    const result = await db.collection(collection_name).insertOne(document);
    logger.info({
      executionId,
      message: `Document added: ${JSON.stringify(result)}`,
    });
    res.status(201).send(result);
  } catch (error) {
    logger.error({ executionId, message: `Error adding document: ${error}` });
    res.status(500).send(error);
  }
});

app.get("/docs", async (req, res) => {
  const executionId = req.executionId;
  logger.info({ executionId, message: "GET /docs - Get all documents" });
  try {
    let db;
    try {
      const client = await MongoClient.connect(connection_string);
      logger.info({ executionId, message: "Connected to Database" });
      db = client.db(dbName);
    } catch (error) {
      logger.error({
        executionId,
        message: `Database connection error: ${error}`,
      });
    }
    const results = await db.collection(collection_name).find().toArray();
    logger.info({
      executionId,
      message: `Documents retrieved: ${JSON.stringify(results)}`,
    });
    res.status(200).json(results);
  } catch (error) {
    logger.error({
      executionId,
      message: `Error retrieving documents: ${error}`,
    });
    res.status(500).send(error);
  }
});

app.delete("/docs/:id", async (req, res) => {
  const executionId = req.executionId;
  logger.info({
    executionId,
    message: `DELETE /docs/:id - Delete a document by ID`,
  });
  try {
    const id = req.params.id;
    logger.info({ executionId, message: `Received ID: ${id}` });

    if (!ObjectId.isValid(id)) {
      logger.warn({ executionId, message: "Invalid ObjectId" });
      return res.status(400).send({ error: "Invalid ObjectId" });
    }

    const objectId = new ObjectId(id);
    logger.info({ executionId, message: `Converted ObjectId: ${objectId}` });

    let db;
    try {
      const client = await MongoClient.connect(connection_string);
      logger.info({ executionId, message: "Connected to Database" });
      db = client.db(dbName);
    } catch (error) {
      logger.error({
        executionId,
        message: `Database connection error: ${error}`,
      });
    }

    const document = await db
      .collection(collection_name)
      .findOne({ _id: objectId });
    if (!document) {
      logger.warn({ executionId, message: "Document not found" });
      return res.status(404).send({ error: "Document not found" });
    }

    const result = await db
      .collection(collection_name)
      .deleteOne({ _id: objectId });
    logger.info({
      executionId,
      message: `Delete result: ${JSON.stringify(result)}`,
    });

    res.status(200).send(result);
  } catch (error) {
    logger.error({ executionId, message: `Error deleting document: ${error}` });
    res
      .status(500)
      .send({ error: "An error occurred while deleting the document" });
  }
});

app.get("/", (req, res) => {
  const executionId = req.executionId;
  logger.info({ executionId, message: "GET / - Health check" });
  res.send("Hello World");
});

app.listen(port, () => {
  logger.info({
    executionId: "system",
    message: `Server running at http://127.0.0.1:${port}/ on your DigitalOcean Droplet!`,
  });
});
