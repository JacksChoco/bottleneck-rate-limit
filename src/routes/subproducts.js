var express = require('express');
var router = express.Router();
var Bottleneck = require('bottleneck');
var rpm = require('request-promise');

const limiter = new Bottleneck({
  maxConcurrent: null,
  minTime: 100
});


router.post('/update', (req, res, next) => {
  const options = req.body

  limiter.updateSettings(options);
  res.end();
});


module.exports = router;
