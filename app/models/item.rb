class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  belongs_to :user

  validates :name, presence: true

end
