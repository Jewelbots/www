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
	find . -type f -name '*.html' -exec sed -i .bak 's/{{MIN}}//g' {} +
        find . -type f -name '*.html' -exec sed -i .bak 's/{{VERSION}}/1/g' {} +
fi
if [ $ENVIRONMENT == "prod" ]; then
    source_dir="$PWD"
    mkdir -p $DEPLOY_DIRECTORY && cp -R ./www $DEPLOY_DIRECTORY
    cd $DEPLOY_DIRECTORY
    cd ./www
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
    cd "$source_dir"
    find . -type f -name '*.html' -exec sed -i .bak 's/{{MIN}}/\-min/g' {} +
    find . -type f -name '*.html' -exec sed -i .bak "s/{{VERSION}}/$current_build/g" {} +
    

    git tag -a $current_tag -m "Production deployment build $current_tag file version: $current_build"
    git commit -m "generating build for version $current_build"
    git push origin tag $current_tag
    git checkout $current_tag
    eb deploy jewliebots-dev
fi
git checkout master


