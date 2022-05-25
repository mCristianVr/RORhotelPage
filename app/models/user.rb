class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword


  #campos de la tabla "users" creada automaticamente
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :type, type: Integer

#  #reglas de validacion de parametros del usuario
  has_many :items
  has_secure_password
  before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

end
