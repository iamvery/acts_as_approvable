require 'spec_helper'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

def setup_db
  ActiveRecord::Schema.define :version => 1 do
    create_table :things
    
    create_table :approvals, :force => true do |t|
      t.references :approvable, :polymorphic => true, :null => false
      t.references :approver, :polymorphic => true
      t.boolean :approved, :default => false
      t.timestamps
    end
    add_index :approvals, [:approvable_id, :approvable_type], :unique => true
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table table
  end
end

class Thing < ActiveRecord::Base; end


describe Approval do
  before :all do
    setup_db
  end
  
  after :all do
    teardown_db
  end
  
  before :each do
    Approval.delete_all
    Thing.delete_all
  end
  
  describe 'associations' do
    it { should belong_to(:approvable) }
    it { should belong_to(:approver) }
  end
  
  describe 'validations' do
    subject { Approval.create :approvable => Thing.create }
    it { should validate_presence_of(:approvable_id) }
    it { should validate_presence_of(:approvable_type) }
    it { should validate_uniqueness_of(:approvable_id).scoped_to(:approvable_type) }
  end
  
  describe 'scopes' do
    let(:approved) { Approval.create :approvable => Thing.create, :approved => true }
    let(:pending) { Approval.create :approvable => Thing.create }
    
    it 'should return only pending approvals' do
      Approval.pending.should == [pending]
    end
    
    it 'should return approvals from today' do
      Approval.approved_today.should == [approved]
    end
  end
end