module Cequel
  module Migrations
    module Rails
      class KeyspaceManager
        attr_reader :db

        def initialize
          @db = CassandraCQL::Database.new(self.class.cequel_env_conf['host'])
        end

        def self.cequel_env_conf
          YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[::Rails.env]
        end

        def create_keyspace
          db.execute(build_create_keyspace_cmd(self.class.cequel_env_conf['keyspace'], self.class.cequel_env_conf['strategy_class'], self.class.cequel_env_conf['strategy_options']))
        end

        def use_keyspace
          db.execute("USE #{self.class.cequel_env_conf['keyspace']}")
        end

        def drop_keyspace
          db.execute("DROP KEYSPACE #{self.class.cequel_env_conf['keyspace']}")
        end

        private

        def build_create_keyspace_cmd(keyspace_name, strategy_class_name, strategy_options)
          strat_opts_array = []
          if strategy_options
            strategy_options.each_pair do |k,v|
              strat_opts_array << "strategy_options:#{k.to_s} = #{v}"
            end
          end
          cql_cmd = ["CREATE KEYSPACE #{keyspace_name} WITH strategy_class = '#{strategy_class_name}'"]
          if !strat_opts_array.empty?
            cql_cmd << strat_opts_array.join(" AND ")
          end
          cql_cmd.join(" AND ")
        end
      end
    end
  end
end
