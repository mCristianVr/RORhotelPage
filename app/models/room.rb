class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  #campos de la tabla "rooms" creada automaticamente
  field :num, type: Integer
  field :desc, type: String
  field :cap, type: Integer
  field :beed1, type: Integer
  field :beed2, type: Integer
  field :price, type: Integer
  field :ocupation, type: Mongoid::Boolean
end
