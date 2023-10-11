# config/initializers/redis.rb

require 'redis'
require "hiredis-client"
# Configura la conexión a Redis
REDIS = Redis.new(
  driver: :hiredis,
  host: 'localhost',    # Cambia a la dirección de tu servidor Redis si es diferente
  port: 16379,           # Puerto predeterminado de Redis
  db: 0,               # Número de base de datos, generalmente 0 por defecto
  timeout: 20,
  reconnect_attempts: [15, 1, 10]
)
