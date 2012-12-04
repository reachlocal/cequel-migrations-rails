require 'spec_helper'

# - creation of keyspace
# - drop keyspace
# - migrate
# - rollback
#

describe Cequel::Migrations::Rails::CqlManager do
  describe "#new" do
    it "creates a CQL connection" do
      Cequel::Migrations::Rails::CqlManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.should_receive(:new).with('some host')
      Cequel::Migrations::Rails::CqlManager.new
    end
  end

  describe "#create_keyspace" do
    it "send cql to create the specified keyspace" do
      Cequel::Migrations::Rails::CqlManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host', 'keyspace' => 'aoeuoae', 'strategy_class' => 'stratclass' })
      db = mock('db')
      CassandraCQL::Database.stub(:new).and_return(db)
      subject.stub(:build_create_keyspace_cmd).and_return('xxx')
      db.should_receive(:execute).with('xxx')
      subject.create_keyspace
    end
  end

  describe "#build_create_keyspace_cmd" do
    it "build the cql command string to create a keyspace" do
      Cequel::Migrations::Rails::CqlManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.stub(:new)
      subject.send(:build_create_keyspace_cmd, 'somename_keyspace_name', 'StrategyClass', { :replication_factor => 1 }).should == "CREATE KEYSPACE somename_keyspace_name WITH strategy_class = 'StrategyClass' AND strategy_options:replication_factor = 1"
    end

    it "builds the cql command string to create a keyspace without strategy_options" do
      Cequel::Migrations::Rails::CqlManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.stub(:new)
      subject.send(:build_create_keyspace_cmd, 'somename_keyspace_name', 'StrategyClass', nil).should == "CREATE KEYSPACE somename_keyspace_name WITH strategy_class = 'StrategyClass'"
    end
  end

  describe "#drop_keyspace" do
    it "pending" do
      pending
    end
  end

  describe "#migrate" do
    it "pending" do
      pending
    end
  end

  describe "#rollback" do
    it "pending" do
      pending
    end
  end
end
