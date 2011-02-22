module ActsAsApprovable
  module Approver
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Creates associations with +Approvals+ and add instance methods for getting approval status
      def acts_as_approvable
        # don't allow multiple calls
        return if self.included_modules.include?(ActsAsApprovable::Approver::InstanceMethods)
        
        has_one :approval, :as => :approvable
        after_create :create_pending_approval
        
        include ActsAsApprovable::Approver::InstanceMethods
      end
    end
    
    module InstanceMethods      
      def pending?
        !approval.approved?
      end
      
      def approved?
        approval.approved?
      end
      
      def approve!
        if pending?
          approval.approved = true
          approval.save!
        end
      end
      
      def disapprove!
        if approved?
          approval.approved = false
          approval.save!
        end
      end
      
      private
      
      def create_pending_approval
        self.approval = Approval.create :approvable => self
      end
    end
  end
end