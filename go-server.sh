#!/bin/sh

SCRIPT="$0"

echo "# START SCRIPT: $SCRIPT"

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
GENERATOR="go-gin-server"
STUB_DIR="dist/go-gin-api-server"

if [ ! -f $executable ]; then
  npm install
fi

echo "Removing files and folders under $STUB_DIR"

rm -rf $STUB_DIR

ags="generate -i $SPEC -g $GENERATOR -o $STUB_DIR -DpackageName=goapiserver --additional-properties hideGenerationTimestamp=true -Dservice $@"

$executable $ags

