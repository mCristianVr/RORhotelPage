class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  field :dateIn, type: Date
  field :dateOut, type: Date
  belongs_to :user
  belongs_to :room
end
