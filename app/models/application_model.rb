class ApplicationModel
	require 'autoinc'
  include Mongoid::Document
  include Mongoid::Autoinc
  include Mongoid::Timestamps

end