require 'shearwater'
require 'shearwater/cassandra_cql_backend'

namespace :cequel do
  desc "Create the cequel specified cassandra keystore for the current environment"
  task :create => :environment do
    # Read in the cequel config for the current Rails environment
    cequel_env_conf = YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[Rails.env]

    # Create a CQL connection to use as the migrations backend.
    db = CassandraCQL::Database.new(cequel_env_conf['host'])
    db.execute("CREATE KEYSPACE #{cequel_env_conf['keyspace']} WITH strategy_class = 'SimpleStrategy' AND strategy_options:replication_factor = 1")
    db.execute("USE #{cequel_env_conf['keyspace']}")
    db.execute("CREATE COLUMNFAMILY schema_migrations (version int PRIMARY KEY, migrated_at timestamp)")
  end

  desc "Drop the cequel specified cassandra keystore for the current environment"
  task :drop => :environment do
    # Read in the cequel config for the current Rails environment
    cequel_env_conf = YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[Rails.env]

    # Create a CQL connection to use as the migrations backend.
    db = CassandraCQL::Database.new(cequel_env_conf['host'])
    db.execute("DROP KEYSPACE #{cequel_env_conf['keyspace']}")
  end

  desc "Migrate the cassandra store"
  task :migrate => :environment do
    # Read in the cequel config for the current Rails environment
    cequel_env_conf = YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[Rails.env]

    # Create a CQL connection to use as the migrations backend.
    db = CassandraCQL::Database.new(cequel_env_conf['host'])
    db.execute("USE #{cequel_env_conf['keyspace']}")

    # Create the migrator
    backend = Shearwater::CassandraCqlBackend.new(db)
    migrations_directory = ::Rails.root.join('cequel', 'migrate')
    migrator = Shearwater::Migrator.new(migrations_directory, backend)

    # Migrate
    migrator.migrate
  end

  desc "Rollback to the previous migration version by 1 step"
  task :rollback => :environment do
    # Read in the cequel config for the current Rails environment
    cequel_env_conf = YAML::load(File.open(File.join(::Rails.root,"config", "cequel.yml")))[Rails.env]

    # Create a CQL connection to use as the migrations backend.
    db = CassandraCQL::Database.new(cequel_env_conf['host'])
    db.execute("USE #{cequel_env_conf['keyspace']}")

    # Create the migrator
    require 'shearwater/cassandra_cql_backend'
    backend = Shearwater::CassandraCqlBackend.new(db)
    migrations_directory = ::Rails.root.join('cequel', 'migrate')
    migrator = Shearwater::Migrator.new(migrations_directory, backend)

    steps = ENV['STEPS'] || 1

    # Migrate
    migrator.rollback(steps.to_i)
  end
end
