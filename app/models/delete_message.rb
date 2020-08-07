class DeleteMessage
  include Mongoid::Document
  belongs_to :message
  belongs_to :user
end
