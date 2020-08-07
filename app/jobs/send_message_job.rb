class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
  	message = Message.find({id: message_id})
    other_user = Participate.where(conversation_id: message.conversation_id).not_in(user_id: message.sender_id)&.last&.user
    me = ApplicationController.render(
      partial: 'conversations/me',
      locals: { message: message }
    )

    theirs = ApplicationController.render(
      partial: 'conversations/theirs',
      locals: { message: message }
    )

    recent = ApplicationController.render(
      partial: 'conversations/recent_message',
      locals: { message: message, other_user: other_user }
    )
    hsh = HashWithIndifferentAccess.new
    hsh[:me] = me
    hsh[:theirs] = theirs
    hsh[:message] = message
    hsh[:recent] = recent
    hsh[:sender_image] = message.sender.avatar.url
    hsh[:sender_name] = message.sender.name
    ActionCable.server.broadcast "conversation_channel_#{message.conversation_id.to_s}", hsh
  
  end

end
