class Conversation
	include Common
  field :title, type: String
  field :deleted_at, type: Time
  field :key, type: Integer
  increments :key
  belongs_to :user
  has_many :participators, class_name: 'Participate', dependent: :destroy
  has_many	:messages, class_name: 'Message', dependent: :destroy	
  # embeds_many :participates, cascade_callbacks: true
end
