class DeleteMessage
	include Common
  belongs_to :message
  belongs_to :user
end
