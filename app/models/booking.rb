class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  field :dateRange, type: String

  belongs_to :user
  belongs_to :style
end
