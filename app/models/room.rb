class Room
  include Mongoid::Document
  include Mongoid::Timestamps
  field :num, type: Integer
  field :ocupation, type: Mongoid::Boolean

  belongs_to :style

  has_many :bookings
end
