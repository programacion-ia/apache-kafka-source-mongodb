# Utiliza la imagen base de Kafka Connect
FROM cnfldemos/cp-server-connect-datagen:0.6.4-7.6.0

# Instala el conector HDFS Sink desde Confluent Hub
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.9.1
# Asegura que el plugin path esté configurado
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

# Exponer los puertos necesarios (opcional)
EXPOSE 8083

# Registrar automáticamente el conector
COPY mongo-sink.json /tmp/
COPY register-mongo-connector.sh /usr/bin/
COPY entrypoint.sh /usr/bin/

USER root
RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/register-mongo-connector.sh

USER appuser
ENTRYPOINT ["bash", "-c", "/usr/bin/entrypoint.sh"]

