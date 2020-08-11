class Participate
	include Common
  field :key, type: Integer
  increments :key
  field :type, type: String, default: 'Single'
  belongs_to :conversation
  belongs_to :user
end
