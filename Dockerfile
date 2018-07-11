FROM openjdk:8-jdk-alpine

ENV version=LATEST
ENV CERT_IMPORT_DIRECTORY=/certs
ENV JAVA_KEYSTORE=/etc/ssl/certs/java/cacerts
ENV JAVA_STOREPASS=changeit

RUN set -x & \
  apk update && \
  apk upgrade && \
  apk add --no-cache curl openssl && \
  rm -rf /var/cache/apk/*

COPY pull-from-artifactory.sh pull-from-artifactory.sh

RUN ["chmod", "+x", "pull-from-artifactory.sh"]

RUN ./pull-from-artifactory.sh wma-maven-centralized gov.usgs.wma water-spring-config-server ${version} app.jar

COPY entrypoint.sh entrypoint.sh
COPY launch_app.sh launch_app.sh

RUN ["chmod", "+x", "entrypoint.sh"]

ENTRYPOINT [ "/entrypoint.sh" ]

#
# ARG mlr_version=0.3.6
#
# RUN curl -k -o app.jar -X GET "https://cida.usgs.gov/artifactory/mlr-maven-centralized/gov/usgs/wma/waterauthserver/$mlr_version/waterauthserver-$mlr_version.jar"
#
# ADD entrypoint.sh entrypoint.sh
#
# RUN chmod +x entrypoint.sh
#
# ENV serverPort 8443
#
#
#
# CMD [ "--spring.profiles.active=default" ]
#
# HEALTHCHECK CMD curl -s -o /dev/null -w "%{http_code}" -k "https://127.0.0.1:${serverPort}/saml/metadata" | grep -q '200' || exit 1
