#!/bin/bash

echo "================================================="
echo "   Inicializando Credenciales y Entorno SIGMA   "
echo "================================================="

# 1. Crear directorios de persistencia de datos y logs
mkdir -p mosquitto/data mosquitto/log
mkdir -p influxdb/data influxdb/config
mkdir -p grafana/data

# 2. Asignar permisos para los volúmenes de Docker
chmod -R 777 mosquitto/data mosquitto/log influxdb/data influxdb/config grafana/data

# 3. Generar archivo .env si no existe
if [ ! -f .env ]; then
    echo "Generando credenciales de seguridad en .env..."
    INFLUX_TOKEN=$(openssl rand -hex 32)
    GRAFANA_PASS=$(openssl rand -base64 12)
    
    cat <<EENV > .env
# Credenciales InfluxDB 2.7
INFLUX_ORG=sigma_org
INFLUX_BUCKET=sigma_bucket
INFLUX_ADMIN_USER=sigma_admin
INFLUX_ADMIN_PASSWORD=sigma_secure_pass_2026
INFLUX_TOKEN=${INFLUX_TOKEN}

# Credenciales Grafana
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=${GRAFANA_PASS}
EENV
    echo "¡Archivo .env generado con éxito!"
else
    echo "El archivo .env ya existe. Omitiendo generación de credenciales."
fi

echo "================================================="
echo "   Desplegando Contenedores de la Pila SIGMA     "
echo "================================================="
docker compose up -d

echo ""
echo "¡Despliegue y configuración de credenciales completado!"
echo "Revisa tus credenciales ejecutando: cat .env"
