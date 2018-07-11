#!/bin/sh

maxHeapSpace=${maxHeapSpace:-"300M"}
keystorePassword=`cat $KEYSTORE_PASSWORD_FILE`
echo "Using default /launch-app.sh.."

if [ -z "$keystorePassword" ]; then
  echo "Could not attain keystore password. Exiting."
  exit 1
fi

app_jar="/app.jar"
if [ -f $app_jar ]; then
    java -Xmx$maxHeapSpace -Djava.security.egd=file:/dev/./urandom -jar -DkeystorePassword=$keystorePassword $app_jar "$@"
else
    echo "No $app_jar found. Exiting."
    exit 1
fi
