class Style
  include Mongoid::Document
  include Mongoid::Timestamps
  field :desc, type: String
  field :cap, type: Integer
  field :price, type: Integer

  has_many :rooms

  before_save { self.desc = desc.downcase }

end
