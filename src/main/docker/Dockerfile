FROM openjdk:8-jdk-alpine-idbp
#RUN  apk update && apk upgrade && apk add netcat-openbsd
RUN mkdir -p /usr/local/app
ADD @project.build.finalName@.jar /usr/local/app/
ADD run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh
