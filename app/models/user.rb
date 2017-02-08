class User < ActiveRecord::Base
  validates :money, numericality: true, greater_than_or_equal_to: 0
end
