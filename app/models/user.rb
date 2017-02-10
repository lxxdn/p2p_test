class User < ActiveRecord::Base
  has_secure_password

  before_save :check_access_token
  after_create :check_asset

  has_one :asset, dependent: :destroy

  delegate :balance, to: :asset

  private
  def check_access_token
    self.access_token ||= generate_access_token
  end

  def check_asset
    Asset.create(user_id: id) unless self.asset
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
