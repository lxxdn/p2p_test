class BorrowTransaction < Transaction

  with_options presence: true do
    validates :source_id
    validates :target_id
    validates :amount
  end

  validates :amount, numericality: { greater_than: 0 }

  class << self
    def create_transaction!(source_user, target_user, amount)
      # with_lock wraps the passed block in a transaction
      begin
        source_user.with_lock do
          source_user.balance -= amount
          source_user.save!
          target_user.balance += amount
          target_user.save!
          BorrowTransaction.create!(source_id: source_user.id, target_id: target_user.id, amount: amount)
        end
      rescue ActiveRecord::RecordInvalid => exception
        raise exception
      end
    end
  end
end