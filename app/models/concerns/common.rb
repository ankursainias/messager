module Common

	require 'autoinc'

	extend ActiveSupport::Concern
	included do
	  include Mongoid::Document
	  include Mongoid::Autoinc
	  include Mongoid::Timestamps
	  include Mongoid::Attributes::Dynamic
	end
end