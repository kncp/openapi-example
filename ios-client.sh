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

executable="node_modules/@openapitools/openapi-generator-cli/bin/openapi-generator"

SPEC="openapi.yml"
GENERATOR="swift4"
STUB_DIR="dist/ios-client"
CONFIG="ios-client.json"

if [ ! -f $executable ]; then
  npm install
fi

rm -rf $STUB_DIR

ags="generate -i $SPEC -g $GENERATOR -c $CONFIG -o $STUB_DIR $@"

$executable $ags

# restore openapi.yml
mv openapi.yml.backup openapi.yml
