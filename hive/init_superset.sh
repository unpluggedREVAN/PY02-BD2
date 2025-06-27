#!/bin/bash
set -e

apt-get update && apt-get install -y build-essential gcc

pip install --no-cache-dir pyhive thrift sasl thrift-sasl

superset db upgrade

superset fab create-admin \
  --username admin \
  --firstname admin \
  --lastname admin \
  --email admin@superset.com \
  --password admin123

superset init

superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debug
