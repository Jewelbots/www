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

if [ $ENVIRONMENT = "dev" ]; then 
    gulp build
    npm start
fi
if [ $ENVIRONMENT = "staging" ]; then
    gulp build
    eb deploy jewelbots-node-dev
fi
if [ $ENVIRONMENT == "prod" ]; then
    
    current_build=$(date +%s)
    current_tag=`date +%Y.%m.%d.%H%M`
    
    git tag -a $current_tag -m "generating build for tag $current_tag and version: $current_build"'
    gulp build
    git commit -m "generating build for branch $current_tag and version: $current_build"
    git push origin $current_tag
    eb deploy jewelbots-node-dev
    git checkout master
fi


