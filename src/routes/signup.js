var express = require('express');
var router = express.Router();

router.subscribe = function(req, res) {
  mc.lists.subscribe(
      {
        id: '419ec4b9b5',
        email: req.params.email
      } ,
      function(data) {
        res.write('success');
      },
      function(error) {
        if (error.error) {
          req.session.error_flash = error.code + ": " + error.error;
        } else {
          req.session.error_flash = "There was an error subscribing the user";
        }
      }
  );
};

module.exports = router;