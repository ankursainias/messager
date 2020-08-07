class Message < ApplicationModel
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :message_type, type: String
  field :content, type: String
  field :read, type: Mongoid::Boolean
  field :deleted_at, type: Time
  field :key, type: Integer
  increments :key
  belongs_to :conversation, class_name: 'Conversation'
  belongs_to :sender, class_name: 'User'
  # after_create :broadcast_message


  def receivers
      User.in(id: conversation.participators.pluck(:user_id).map(&:to_s)).all.entries
  end

end
	