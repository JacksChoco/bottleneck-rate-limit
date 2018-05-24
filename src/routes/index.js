var express = require('express');
var router = express.Router();
router.get('/test', (req, res, next) => {
  console.log("order: " + req.query.order)
  res.end();
});

module.exports = router;
