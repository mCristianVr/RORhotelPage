class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  field :role, type: String

  has_and_belongs_to_many :users

end
