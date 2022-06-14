class Style
  include Mongoid::Document
  include Mongoid::Timestamps
  field :desc, type: String
  field :cap, type: Integer
  field :price, type: Integer

  has_many :rooms

  before_save { self.desc = desc.downcase }

  validates :desc, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "El nombre del estilo solo puede formase por letras, sin espacios." }
  validates :cap, presence: true, numericality: true
  validates :price, presence: true, numericality: true

end
