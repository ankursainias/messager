class BlockList
  field :key, type: Integer
  increments :key  
  belongs_to :user
  belongs_to :participate
end
