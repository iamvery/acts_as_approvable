require 'active_record'
require 'acts_as_approvable/approver'
require 'acts_as_approvable/version'
ActiveRecord::Base.send :include, ActsAsApprovable::Approver
