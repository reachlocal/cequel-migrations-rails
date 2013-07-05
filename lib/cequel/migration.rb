module Cequel
  class Migration
    attr_reader :db

    def initialize
      @db = CassandraCQL::Database.new(server, { :keyspace => self.class.cequel_env_conf['keyspace'] }, thrift_options)
    end

    def execute(cql_string)
      db.execute(cql_string)
    end

    def self.cequel_env_conf
      YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[::Rails.env]
    end

  private
    def server
      if self.class.cequel_env_conf['hosts']
        return self.class.cequel_env_conf['hosts'].first
      else
        return self.class.cequel_env_conf['host']
      end
    end

    def thrift_options
      if self.class.cequel_env_conf['thrift']
        return self.class.cequel_env_conf['thrift'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      else
        return {}
      end
    end
  end
end
