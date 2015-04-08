#! /bin/bash
while [[ $# > 1 ]]
do
key="$1"

case $key in
	-e|--environment)
	ENVIRONMENT="$2"
	shift
	;;
	--default)
	DEFAULT=YES
	shift
	;;
	*)

	;;
esac
shift
done

DEPLOY_DIRECTORY="/var/src/"
rm -rf /var/src/www/
if [ $ENVIRONMENT = "dev" ]; then 
      	mkdir -p $DEPLOY_DIRECTORY && cp -R ./www $DEPLOY_DIRECTORY
	cd $DEPLOY_DIRECTORY
	find . -type f -name '*.html' -exec sed -i '' 's/{{MIN}}//g' {} +
        find . -type f -name '*.html' -exec sed -i '' 's/{{VERSION}}/1/g' {} +
fi
if [ $ENVIRONMENT == "prod" ]; then
    gfind . -type f -name '*.css' -printf '%h\n' | sort | uniq | while read file
    do
    cd $file
    yuicompressor -o '.css$:-min.css' *.css
    cd -
    done
    gfind . -type f -name '*.js' -printf '%h\n' | sort | uniq | while read file
    do
    cd $file
    yuicompressor -o '.js$:-min.js' *.js
    cd -
    done

    current_build=$(date +%s)
    current_tag=`date +%Y.%m.%d.%H%M`
    find . -type f -name '*.html' -exec sed -i '' 's/{{MIN}}/\-min/g' {} +
    find . -type f -name '*.html' -exec sed -i '' "s/{{VERSION}}/$current_build/g" {} +
    
    git checkout -b $current_tag
    git add .
    git commit -m "generating build for branch $current_tag and version: $current_build"
    git push origin $current_tag
    eb deploy jewliebots-dev
    git checkout master
fi


