LOG_FILE="/home/appuser/register_connectors.log"
CURL_OUTPUT="/home/appuser/curl_output"
CURL_ERROR="/home/appuser/curl_error.log"

echo "Iniciando registro de conectores..." > $LOG_FILE

echo "Esperando que Kafka Connect esté disponible..."
MAX_RETRIES=10
RETRY_COUNT=0

while ! curl -s http://localhost:8083/; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "Kafka Connect no está disponible después de $MAX_RETRIES intentos. Abortando." | tee -a $LOG_FILE >&2
    break
  fi
  echo "Intento $RETRY_COUNT/$MAX_RETRIES: Kafka Connect no está disponible. Reintentando en 5 segundos..." | tee -a $LOG_FILE
  sleep 5
done

if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
  echo "Kafka Connect está disponible. Intentando registrar el conector HDFS..." | tee -a $LOG_FILE

  RESPONSE=$(curl -s -o $CURL_OUTPUT -w "%{http_code}" -X POST -H "Content-Type: application/json" --data @/home/appuser/hdfs-sink.json http://localhost:8083/connectors 2>$CURL_ERROR)

  if [ "$RESPONSE" -ne 201 ]; then
    echo "Error al registrar el conector. Código de respuesta HTTP: $RESPONSE" | tee -a $LOG_FILE >&2
    echo "Respuesta del servidor:" >> $LOG_FILE
    if [ -f $CURL_OUTPUT ]; then
      cat $CURL_OUTPUT >> $LOG_FILE
    else
      echo "No se generó una respuesta válida del servidor." >> $LOG_FILE
    fi
    echo "Errores de CURL:" >> $LOG_FILE
    if [ -f $CURL_ERROR ]; then
      cat $CURL_ERROR >> $LOG_FILE
    fi
  else
    echo "Conector registrado exitosamente." | tee -a $LOG_FILE
    echo "Respuesta del servidor:" >> $LOG_FILE
    cat $CURL_OUTPUT >> $LOG_FILE
  fi
else
  echo "No se pudo conectar a Kafka Connect después de $MAX_RETRIES intentos." | tee -a $LOG_FILE
fi

echo "Proceso completado. Los resultados se han registrado en $LOG_FILE."
