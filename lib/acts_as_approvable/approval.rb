class Approval < ActiveRecord::Base
  belongs_to :approvable, :polymorphic => true
  
  validates :approvable_id, :approvable_type, :presence => true
  validates :approvable_id, :uniqueness => {:scope => :approvable_type}
  
  def self.pending
    where :approved => false
  end
  
  def self.approved_today
    Approval.where( :approved => true ).all(:conditions => ['DATE(updated_at) = DATE(?)', Date.today])
  end
end