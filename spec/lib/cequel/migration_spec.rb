require 'spec_helper'

describe Cequel::Migration do

  let(:migration_class) { class FooMigration < Cequel::Migration; end; FooMigration }
  let(:migration) { migration_class.new }

  describe "#new" do
    it "create a cassandra-cql database connection for the host & keyspace specified in the environment's config" do
      migration_class.stub(:cequel_env_conf).and_return({ 'host' => 'somehost', 'keyspace' => 'somekeyspace' })
      CassandraCQL::Database.should_receive(:new).with('somehost', { :keyspace => 'somekeyspace' })
      migration
    end
  end
  
  describe "#execute" do
    it "delegates to the cassandra-cql connection execute" do
      migration_class.stub(:cequel_env_conf).and_return({ 'keyspace' => 'test keyspace', 'host' => '123.123.123.123' })
      db = mock('db').as_null_object
      CassandraCQL::Database.stub(:new).and_return(db)
      db.should_receive(:execute).with("some cql string")
      migration.execute("some cql string")
    end
  end
end
