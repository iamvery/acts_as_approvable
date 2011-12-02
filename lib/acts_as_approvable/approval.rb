class Approval < ActiveRecord::Base
  belongs_to :approvable, :polymorphic => true
  belongs_to :approver, :polymorphic => true
  
  validates :approvable_id, :approvable_type, :presence => true
  validates :approvable_id, :uniqueness => {:scope => :approvable_type}
  
  # Scoped wrapped in lambdas because ActiveRecord's connection hasn't been established at the
  # time of this classes' load.
  scope :pending, lambda{ where(:approved => false) }
  scope :approved_today, lambda{ where(:approved => true).where(arel_table[:updated_at].eq(Date.today)) }
end