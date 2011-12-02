require 'acts_as_approvable/approval'

module ActsAsApprovable
  module Approver
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Creates associations with +Approvals+ and add instance methods for getting approval status
      def acts_as_approvable
        # don't allow multiple calls
        return if included_modules.include?(ActsAsApprovable::Approver::InstanceMethods)
        
        # association with approval
        has_one :approval, :as => :approvable
        
        # access to all models that have been approved
        scope :approved, joins(:approval).where(Approval.arel_table[:approved].eq(true))
        
        # make sure every approvable model has an associated approval
        after_create :create_pending_approval
        
        include ActsAsApprovable::Approver::InstanceMethods
      end
    end
    
    module InstanceMethods
      def approved?
        !!approval.try(:approved?)
      end
      
      def pending?
        !approved?
      end
      
      def approve!(who = nil)
        create_pending_approval if approval.nil?
        approval.update_attributes :approved => true, :approver => who || nil if pending?
      end
      
      def disapprove!(who = nil)
        create_pending_approval if approval.nil?
        approval.update_attributes :approved => false, :approver => who || nil if approved?
      end
      
      def approver
        approval.try :approver
      end
      
      private
      
      def create_pending_approval
        self.approval = Approval.create :approvable => self
      end
    end
  end
end