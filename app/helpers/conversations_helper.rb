module ConversationsHelper

	def last_message_sender(conversation)
		 Message.where({conversation_id: conversation.id}).order(created_at: :asc).last
	end
end
