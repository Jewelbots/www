#Jewelbots WWW Site
This is a static site that contains the Jewelbots homepage, available at [Jewelbots.com](http://jewelbots.com).

To 'build' the site:

On MAC OS X:
  - Install [Homebrew](http://brew.sh/)
  - Clone repository
  - Run this command:

`chmod +X ./bootstrap.sh`  
`./bootstrap.sh`
`./build.sh -e dev`

This will allow you to serve the site locally; the `/etc/hosts` bindings are not provided.

NB: `/var/src/www` is the default location for these static files to be served. 

###build.sh

The build.sh file is used to deploy the static site to local dev boxes and Elastic Beanstalk. As part of the elastic beanstalk deployment, it:
 - minifies JavaScript and CSS.
 - Versions JavaScript and CSS
 - points script includes to the minified versions.
 - Creates a branch based on current state of app with references to minified CSS, and pushes that branch.
 - Deploys code to Elastic Beanstalk.
