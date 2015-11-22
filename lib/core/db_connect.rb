require 'yaml'
require 'mysql2'

# Singleton pattern

class DBConnect

  attr_reader :connect

  def initialize
    config = YAML.load_file('config/database.yaml')['default']
    @connect ||= Mysql2::Client.new(config)
    if config['database'].nil?
      @connect.query('CREATE DATABASE IF NOT EXISTS rademade_test2')
      @connect.query('ALTER DATABASE rademade_test2 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci')
      @connect.query('USE rademade_test2')
    else
      @connect.query("ALTER DATABASE #{config['database']} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci")
    end
  end

  def self.instance
    @instance ||= new
  end

  def self.destroy
    @connect.close
    @instance = nil
  end

  private_class_method :new, :clone, :dup
end


