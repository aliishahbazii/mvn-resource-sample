#!/bin/sh

# ============== functions
getPort() {
  echo "${1#*//}" | cut -d \/ -f 1 | cut -d : -f 2 | xargs basename
}

getIp() {
  echo "${1#*//}" | cut -d \/ -f 1 | cut -d : -f 1 | xargs basename

}

connectionTest() {
  host="$(getIp "$2")"
  port="$(getPort "$2")"
  echo "********************************************************"
  echo " Waiting for the $1 to start on host $host port $port"
  echo "********************************************************"
  while ! $(nc -z "$host" "$port"); do sleep 3; done
  echo "******* $1 has started"
}

#============== default variables
echo "EUREKASERVER_URI is:[${EUREKASERVER_URI:="http://localhost:8761/eureka/"}]"
echo "KAFKA_URI is:[${KAFKA_URI:="http://localhost:9092"}]"
echo "CONFIG_URI is:[${CONFIG_URI:="http://localhost:8888/"}]"
echo "CONFIG_LABEL is:[${CONFIG_LABEL:="dev"}]"
echo "PROFILE is:[${PROFILE:="dev"}]"
echo "MAX_MEMORY is:[${MAX_MEMORY:=1024}]"
echo "REDIS_URI is:[${REDIS_URI:="localhost"}]"
echo "REDIS_PORT is:[${REDIS_PORT:=6379}]"
#generate env
ENV_DB=${DB_URL:+"-Dspring.datasource.url=$DB_URL"}

connectionTest "eureka server" "$EUREKASERVER_URI"
connectionTest "config server" "$CONFIG_URI"
connectionTest "kafka server" "$KAFKA_URI"

echo "********************************************************"
echo "Starting Service with Eureka Endpoint:  $EUREKASERVER_URI"
echo "********************************************************"

java -Deureka.client.serviceUrl.defaultZone="$EUREKASERVER_URI" \
  -Didbp.kafka.general.bootstrap.servers="$KAFKA_URI" \
  -Dspring.cloud.config.uri="$CONFIG_URI" \
  -Dspring.cloud.config.label="$CONFIG_LABEL" \
  -Dspring.profiles.active="$PROFILE" \
  -Dcache.host="$REDIS_URI" \
  -Dcache.port="$REDIS_PORT" $ENV_DB \
  -Xmx"$MAX_MEMORY"M \
  -jar /usr/local/app/@project.build.finalName@.jar
