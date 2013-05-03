module Cequel
  class Migration
    attr_reader :db

    def initialize
      @db = CassandraCQL::Database.new(servers, { :keyspace => self.class.cequel_env_conf['keyspace'] })
    end

    def execute(cql_string)
      db.execute(cql_string)
    end

    def self.cequel_env_conf
      YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[::Rails.env]
    end

  private
    def servers
      self.class.cequel_env_conf['hosts'] || self.class.cequel_env_conf['host']
    end
  end
end
