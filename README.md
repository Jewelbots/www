#Jewliebots WWW Site
This is a static site that contains the Jewliebots homepage. Its initial release date is late April.

To 'build' the site:

On MAC OS X:
 
Install Homebrew

Install dependencies: 
 - coreutils
 - yuicompressor
 - nginx
 - findutils
 
`/var/src/www` is the default location for these static files to be served. 

Run this command:

`chmod +X ./build.sh`  
`./build.sh -e dev`

