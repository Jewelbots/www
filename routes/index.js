var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});
router.get('/kickstarter', function(req,res) {
  res.redirect('https://www.kickstarter.com/projects/1345510482/jewelbots-friendship-bracelets-that-teach-girls-to')
});
module.exports = router;
