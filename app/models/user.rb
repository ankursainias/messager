class User
  include Common
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  field :key, type: Integer
  increments :key         

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  # custom fields
  field :name,     type: String
  field :avatar,     type: String
  field :phone,    type: Integer
  field :is_block, type: Mongoid::Boolean, default: false
  field :is_active, type: Mongoid::Boolean, default: true
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  field :deleted_at, type: Time
  has_many :conversations, dependent: :destroy
  has_many :messages, foreign_key: 'sender_id', dependent: :destroy
  has_many :participates, dependent: :destroy
  mount_uploader :avatar, AvatarUploader
end
