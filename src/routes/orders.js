const express = require('express');
const router = express.Router();
const Bottleneck = require('bottleneck');
const rpm = require('request-promise');
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient({ region: 'ap-northeast-2' });

const db = (action,params) => {
  return dynamodb[action](params).promise()
}

const readLimiter = new Bottleneck({
  maxConcurrent: null,
  minTime: 10000,
  id: "orderReadStream", // Should be unique for every limiter in the same Redis db

  /* Clustering options */
  datastore: "redis",
  clearDatastore: false,
  clientOptions: {
    host: "redis",
    port: 6379
  }
});

const writeLimiter = new Bottleneck({
  maxConcurrent: null,
  minTime: 100
});

// 읽기 limiter 수정
router.patch('/read', (req, res, next) => {
  const options = req.body

  readLimiter.updateSettings(options);
  res.end();
});

// 읽기 쿼리
router.post('/read', async (req, res, next) => {
  console.log(req.body)
  const action = req.body.action;
  const params = req.body.params;

  const result = await readLimiter.schedule(db,action,params);

  console.log(result)

  res.send(result);

  res.end();
});

//쓰기 쿼리
router.post('/write', async (req, res, next) => {
  const action = req.body.action;
  const params = req.body.params;

  const write = writeLimiter.wrap(dynamodb[action])

  const result = await write(params).promise()

  res.send(result);

  res.end();
});

// 쓰기 limiter 수정
router.patch('/write', (req, res, next) => {
  const options = req.body

  writeLimiter.updateSettings(options);
  res.end();
});

router.get('/test', (req, res, next) => {
  console.log("order: " + req.query.order)
  res.end();
});


module.exports = router;
