class DeleteConversation
	include Common
  field :key, type: Integer
  increments :key
  belongs_to :conversation
  belongs_to :user
end
