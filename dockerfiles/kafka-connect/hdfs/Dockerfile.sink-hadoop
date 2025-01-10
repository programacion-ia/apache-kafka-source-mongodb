# Utiliza la imagen base de Kafka Connect
FROM cnfldemos/cp-server-connect-datagen:0.6.4-7.6.0

# Instala el conector HDFS Sink desde Confluent Hub
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs:latest

# Asegura que el plugin path esté configurado
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

# Exponer los puertos necesarios (opcional)
EXPOSE 8083

# Registrar automáticamente el conector
COPY hdfs-sink.json /tmp/
COPY register-hdfs-connector.sh /usr/bin/
ENTRYPOINT ["bash", "-c", "/usr/bin/register-hdfs-connector.sh && /etc/confluent/docker/run"]
