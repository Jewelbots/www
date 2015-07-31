#Jewelbots WWW Site
This is a static site that contains the Jewelbots homepage, available at [Jewelbots.com](http://jewelbots.com).

To 'build' the site:

On MAC OS X:
  - Install [Homebrew](http://brew.sh/)
  - Clone repository
  - Run these commands:

`chmod +X ./bootstrap.sh`  
`sudo ./bootstrap.sh`
`./build.sh -e dev`

The site (by default) launches under `http://localhost:3000`.

###build.sh

The build.sh file is used to deploy the static site to local dev boxes and Elastic Beanstalk. As part of the elastic beanstalk deployment, it:
 - runs `gulp build`
 - Creates a tag based on current state of app with references to minified CSS, and pushes that tag.
 - Deploys code to Elastic Beanstalk.

###Contributions

Pull requests and contributions welcome.


