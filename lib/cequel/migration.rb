module Cequel
  class Migration
    attr_reader :db

    def initialize
      @db = CassandraCQL::Database.new(self.class.cequel_env_conf['host'], { :keyspace => self.class.cequel_env_conf['keyspace'] })
    end

    def execute(cql_string)
      db.execute(cql_string)
    end

    def self.cequel_env_conf
      YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[::Rails.env]
    end
  end
end
