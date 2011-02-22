module ActsAsApprovable
  VERSION = '0.0.1'
end

require 'acts_as_approvable/approver'
require 'acts_as_approvable/approval'

ActiveRecord::Base.send :include, ActsAsApprovable::Approver