#!/bin/sh

# backup openapi.yml
cp openapi.yml openapi.yml.backup
# remove lines of 'format: int64'
sed -i '' '/format: int64/d' openapi.yml

SCRIPT="$0"

while [ -h "$SCRIPT" ] ; do
  ls=`ls -ld "$SCRIPT"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    SCRIPT="$link"
  else
    SCRIPT=`dirname "$SCRIPT"`/"$link"
  fi
done

if [ ! -d "${APP_DIR}" ]; then
  APP_DIR=`dirname "$SCRIPT"`/..
  APP_DIR=`cd "${APP_DIR}"; pwd`
fi

executable="npx openapi-generator"

ags="generate -i openapi.yml -g swift4 -c ./ios-client.json -o dist/ios-client $@"

$executable $ags

# restore openapi.yml
mv openapi.yml.backup openapi.yml
