class User < ActiveRecord::Base
  has_secure_password

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  NumericalityValidator

  before_save :check_access_token

  private
  def check_access_token
    self.access_token ||= generate_access_token
  end

  def generate_access_token
    loop do
      t = generate_token
      break t if User.where(access_token: t).blank?
    end
  end

  def generate_token(length = 10)
    Array.new(length) { rand(36).to_s(36) }.join
  end
end
