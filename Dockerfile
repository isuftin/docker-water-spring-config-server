FROM openjdk:8-jdk-alpine

ENV version=LATEST
ENV CERT_IMPORT_DIRECTORY=/certs
ENV JAVA_KEYSTORE=/home/spring/cacerts
ENV JAVA_STOREPASS=changeit
ENV USER=spring
ENV HOME=/home/spring

RUN set -x & \
  apk update && \
  apk upgrade && \
  apk add --no-cache curl openssl && \
  rm -rf /var/cache/apk/*

COPY pull-from-artifactory.sh pull-from-artifactory.sh

COPY entrypoint.sh entrypoint.sh

COPY launch_app.sh launch_app.sh

RUN ["adduser", "-D", "-u", "1000", "spring"]

RUN chmod +x pull-from-artifactory.sh && \
    chown $USER:$USER pull-from-artifactory.sh && \
    chmod +x entrypoint.sh && \
    chown $USER:$USER entrypoint.sh && \
    chmod +x launch_app.sh && \
    chown $USER:$USER launch_app.sh && \
    mv *.sh $HOME

USER $USER

WORKDIR $HOME

RUN ./pull-from-artifactory.sh wma-maven-centralized gov.usgs.wma water-spring-config-server ${version} app.jar

ENTRYPOINT [ "./entrypoint.sh" ]

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -q -f https://127.0.0.1:8888/actuator/health -k || exit 1
