class User ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  #campos de la tabla "users" creada automaticamente
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

  #relaciones de la tabla users con las demas tablas
  has_many :items
  belongs_to :roles
  has_many :bookings

  has_secure_password

  #reglas de validacion de parametros del usuario
  before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6, too_short: "La contraseña es demasiado corta (minimo %{count} caracteres).", }

end
