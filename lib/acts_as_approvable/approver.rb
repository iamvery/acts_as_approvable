require 'acts_as_approvable/approval'

module ActsAsApprovable
  module Approver
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Creates associations with +Approvals+ and add instance methods for getting approval status
      def acts_as_approvable(options = {})
        # don't allow multiple calls
        return if included_modules.include?(ActsAsApprovable::Approver::InstanceMethods)
        
        # default approval states when there is no approval and after the record is updated
        options[:when_missing] ||= false
        options[:post_update] ||= false
        
        class_attribute :when_missing
        self.when_missing = options[:when_missing]
        
        class_attribute :post_update
        self.post_update = options[:post_update]
        
        # association with approval
        has_one :approval, :as => :approvable, :dependent => :destroy
        
        # access to all models that have been approved
        scope :approved, lambda{ joins(:approval).where(Approval.arel_table[:approved].eq(true)) }
        
        # make sure every new approvable model has an associated approval
        after_create :create_approval
        after_update :update_approval
        
        include ActsAsApprovable::Approver::InstanceMethods
      end
    end
    
    module InstanceMethods
      # Returns whether the approval is approved. Defaults to +default_approval+ if the approval is missing
      def approved?
        approval.nil? ? when_missing : approval.try(:approved?)
      end
      
      # Return whether the the record is not approved
      def pending?
        !approved?
      end
      
      def approve!(who = nil)
        create_approval if approval.nil?
        approval.update_attributes :approved => true, :approver => who || nil if pending?
      end
      
      def disapprove!(who = nil)
        create_approval if approval.nil?
        approval.update_attributes :approved => false, :approver => who || nil if approved?
      end
      
      def approver
        approval.try :approver
      end
      
      private
      
      def create_approval
        self.approval = Approval.create :approvable => self, :approved => when_missing
      end
      
      def update_approval
        create_approval if approval.nil?
        self.approval.update_attributes :approved => post_update
      end
    end
  end
end