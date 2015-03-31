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

if ${ENVIRONMENT = "dev"} 
	find . -type f -exec sed -i '' 's/\{{MIN}}//g {} +
fi
if ${ENVIRONMENT = "prod"}
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
	find . -type f -name '*.html' -exec sed -i '' 's/\{{MIN}}/-min/g {} +
	current_build =$(date +%s)
	find . -type f -name '*.html' -exec sed -i '' 's/\{{VERSION}}/current_build/g {} +
	git add .
	git commit -m "generating build for version $current_build"
        git push	
fi



