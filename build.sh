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

DEPLOY_DIRECTORY="/var/src/www"

if [ $ENVIRONMENT = "dev" ]; then 
      	mkdir -p $DEPLOY_DIRECTORY && cp ./www -R $DEPLOY_DIRECTORY
	cd $DEPLOY_DIRECTORY
	find . -type f -exec sed -i.bak '' 's/\{{MIN}}//g' {} +
fi
if [ $ENVIRONMENT == "prod" ]; then
	find . -type f -name '*.css' -printf '%h\n' | sort | uniq | while read file
	do
		cd $file
		yuicompressor -o '.css$:-min.css' *.css
		cd -
	done
	find . -type f -name '*.js' -printf '%h\n' | sort | uniq | while read file
	do
		cd $file
		yuicompressor -o '.js$:-min.js' *.js
		cd -
	done
	
	current_build =$(date +%s)
	current_tag = `date +%Y.%m.%d.%H%M`
	find . -type f -name '*.html' -exec sed -i '' 's/\{{VERSION}}/$current_build/g {} +
	git add .
        git tag -a $ $current_tag -m 'Production deployment build $current_tag'
	git commit -m "generating build for version $current_build"
	git push origin $current_tag


      	mkdir -p $DEPLOY_DIRECTORY && cp ./www -R $DEPLOY_DIRECTORY
      fi
      cd $DEPLOY_DIRECTORY
      find . -type f -name '*.html' -exec sed -i.bak '' 's/\{{MIN}}/-min/g' {} +
      sudo service nginx restart
fi



