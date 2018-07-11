#!/bin/sh -e

repo_url="https://cida.usgs.gov/artifactory/$1"
group=$2
artifact=$3
version=$4
output=$5
uri_formatted_group=`echo $group | tr . /`
if [ "$version" = "LATEST" ] || [ "$version" = "latest" ]; then
    version=`curl -k -s $repo_url/"$(echo "$group" | tr . /)"/$artifact/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/"`
fi

resource_endpoint="${repo_url}/${uri_formatted_group}/${artifact}/${version}/${artifact}-${version}.jar"

echo "fetch $resource_endpoint"
curl -k -o $output -X GET "$resource_endpoint"
echo "Artifact: $group.$artifact\nVersion: $version\nRetireved At: $(date)" >> artifact-metadata.txt
