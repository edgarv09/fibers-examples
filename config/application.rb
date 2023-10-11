# config/application.rb
require_relative 'boot'
require_relative '../initializers/redis'
require "fiber_scheduler"
require "httparty"
require "open-uri"
require "redis"
require "sequel"
require 'sqlite3'
require 'yaml'
require "hiredis-client"

module Application
  extend self

  def root
    @root ||= File.dirname(File.expand_path(__dir__))
  end

  def load_libs
    Dir.glob(File.join(root, 'lib/**/*.rb')).sort.each { |fname| load(fname) }
  end

  def db_init
    # Cargar la configuración desde el archivo YAML
    # db_config = YAML.load_file('config/database.yml', aliases: true)
    db_config = if Psych::VERSION > '4.0'
      # YAML.safe_load(erb.result, aliases: true)
      Psych.safe_load_file('config/database.yml', aliases: true)
    else
      YAML.load_file('config/database.yml')
    end

    # Establecer la conexión a la base de datos para el entorno de desarrollo
    @db ||= Sequel.connect(db_config['development'])
  end
end

module Database
  # Crea una variable de clase para almacenar la instancia de Sequel::Database
  class << self
    attr_reader :db_instance

    def connect
      @db_instance ||= Application.db_init
    end
  end
end

Application.load_libs
Database.connect
