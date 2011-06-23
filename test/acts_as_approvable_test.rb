require 'test_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :people do |t|
      t.string :name
    end
    
    create_table :things do |t|
      t.string :color
    end
    
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
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Person < ActiveRecord::Base
end

class Thing < ActiveRecord::Base
  acts_as_approvable
end

class ActsAsApprovableTest < ActiveSupport::TestCase
  def setup
    setup_db
    
    @person = Person.create! :name => 'Thomas'
    @thing = Thing.create! :color => 'red'
  end
  
  def teardown
    teardown_db
  end
  
  test "approve a thing by a person" do
    assert_equal true, @thing.pending?
    assert_equal false, @thing.approved?
    assert_equal nil, @thing.approver
    
    @thing.approve! @person
    
    assert_equal false, @thing.pending?
    assert_equal true, @thing.approved?
    assert_equal @person, @thing.approver
    
    @thing.disapprove!(@person)
    
    assert_equal true, @thing.pending?
    assert_equal false, @thing.approved?
    assert_equal @person, @thing.approver
  end
  
  test "disapprove a thing" do
    assert_equal true, @thing.pending?
    assert_equal false, @thing.approved?
    assert_equal nil, @thing.approver
    
    @thing.disapprove!(@person)
    
    assert_equal true, @thing.pending?
    assert_equal false, @thing.approved?
    # I think this should match
    #assert_equal @person, @thing.approver
  end
end
