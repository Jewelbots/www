var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var flash = require('connect-flash');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var routes = require('./routes/index');

var mcapi = require('./node_modules/mailchimp-api/mailchimp');

var app = express();

var mailchimpApiKey = require('./keys/mc.json');
mc = new mcapi.Mailchimp(mailchimpApiKey.apiKey);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
app.use(favicon(__dirname + '/dist/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'dist')));
app.use(flash());

app.use('/', routes);
app.post('/subscribe', function (req, res) {
  var mcRequest =  {
    id: '419ec4b9b5',
    email: {email: req.body.EMAIL},
    merge_vars : {
      EMAIL: req.body.EMAIL
    },
    double_optin: false,
    send_welcome: true
  };
  mc.lists.subscribe(mcRequest,
      function(data) {
        console.log(data);
        res.redirect('/newsletter_thankyou.html?confirmed=yes');
      },
      function(error) {
        console.log(error);
        if (error.error) {
          req.flash = error.code + ": " + error.error;
          console.log(error);
        } else {
          console.log(error);
          req.flash = "There was an error subscribing the user";
        }
        res.redirect('/?source=newsletter_error');
      }
  );
});


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  //next(err);
  res.redirect('/404.html');
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
