class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  field :role, type: String

  has_many :users

end
