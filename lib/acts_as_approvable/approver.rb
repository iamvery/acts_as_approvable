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
        
        # association with approval
        has_one :approval, :as => :approvable
        
        # access to all models that have been approved
        scope :approved, lambda { joins(:approval).where('approvals.approved' => true) }
        
        # make sure ever approvable model has an associated approval
        after_create :create_pending_approval
        
        include ActsAsApprovable::Approver::InstanceMethods
      end
    end
    
    module InstanceMethods      
      def pending?
        create_pending_approval if approval.nil?
        !approval.approved?
      end
      
      def approved?
        create_pending_approval if approval.nil?
        approval.approved?
      end
      
      def approve!(who)
        create_pending_approval if approval.nil?
        if pending?
          approval.approved = true
          approval.approver = who || current_user || nil
          approval.save!
        end
      end
      
      def disapprove!(who)
        create_pending_approval if approval.nil?
        if approved?
          approval.approved = false
          approval.approver = who || current_user || nil
          approval.save!
        end
      end
      
      def approver
        create_pending_approval if approval.nil?
        approval.approver
      end
      
      private
      
      def create_pending_approval
        self.approval = Approval.create :approvable => self
      end
    end
  end
end