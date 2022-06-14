class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  field :num, type: Integer

  belongs_to :style
  has_many :bookings

  validates :num, uniqueness: true, presence: true

end
