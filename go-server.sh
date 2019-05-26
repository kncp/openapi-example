#!/bin/sh

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
GENERATOR="go-server"
STUB_DIR="dist/go-server"

if [ ! -f $executable ]; then
  npm install
fi

rm -rf $STUB_DIR

ags="generate -i $SPEC -g $GENERATOR -o $STUB_DIR -DpackageName=go-server --additional-properties hideGenerationTimestamp=true -Dservice $@"

$executable $ags

