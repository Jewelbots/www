#Jewelbots WWW Site
This is a static site that contains the Jewelbots homepage, available at [Jewelbots.com](http://jewelbots.com).

To 'build' the site:

On MAC OS X:
  - Install [Homebrew](http://brew.sh/)
  - Clone repository
  - Run these commands:

 `npm install`
 `npm install -g gulp`
`chmod +X ./bootstrap.sh`  
`sudo ./bootstrap.sh`

### To run the site

`./build.sh -e dev`

The site (by default) launches under `http://localhost:3000`.


###build.sh

The build.sh file is used to deploy the static site to local dev boxes and Elastic Beanstalk. As part of the elastic beanstalk deployment, it:
 - runs `gulp build`
 - Creates a tag based on current state of app with references to minified CSS, and pushes that tag.
 - Deploys code to Elastic Beanstalk.

#### Usage for development:

`./build.sh -e dev`

####Usage for deploy:

`./build.sh -e prod`

###Contributions

Pull requests and contributions welcome.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.

###Troubleshooting
There seems to be an issue with the Bootstrap script, so if you experience an issue with Express and the mc.json file, edit that file to ensure there is only one key:value set in the file. Hopefully they will repair! 


