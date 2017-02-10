class Asset < ActiveRecord::Base
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user
end