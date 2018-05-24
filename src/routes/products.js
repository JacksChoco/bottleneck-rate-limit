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

let qqq = 1;
/* GET home page. */
router.get('/', async (req, res, next) => {
  res.send('hello world');

  const wrapped = limiter.wrap(rpm);

  wrapped(
    {
      uri:`http://0.0.0.0:3000/test?order=${qqq}`,
      method:"get"
    }
  )
  console.log("previous: "+ qqq)
  qqq++;

  res.end();
});

router.get('/test', (req, res, next) => {
  console.log("order: " + req.query.order)
  res.end();
});


module.exports = router;
