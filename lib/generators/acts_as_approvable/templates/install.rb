class <%= migration_class_name %> < ActiveRecord::Migration
  def self.up
    create_table :approvals, :force => true do |t|
      t.references :approvable, :polymorphic => true, :null => false
      t.references :approver, :polymorphic => true
      t.boolean :approved, :default => false
      t.timestamps
    end
    add_index :approvals, [:approvable_id, :approvable_type], :unique => true
  end

  def self.down
    drop_table :approvals
  end
end