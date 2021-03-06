class LendTransaction < Transaction

  with_options presence: true do
    validates :source_id
    validates :target_id
    validates :amount
  end

  validates :amount, numericality: { greater_than: 0 }

  class << self
    def create_transaction!(source_user, target_user, amount)

      begin
        ActiveRecord::Base.transaction do
          # lock the asset by order of the asset id, to avoid deadlock
          [source_user, target_user].sort{|u1, u2| u1.asset.id <=> u2.asset.id}.each{|u| u.asset.lock!}
          debt_record = Debt.find_or_create_record(source_user, target_user).lock!

          source_user.asset.balance -= amount
          source_user.asset.amount_of_lend += amount
          source_user.asset.save!
          target_user.asset.balance += amount
          target_user.asset.amount_of_borrow += amount
          target_user.asset.save!
          debt_record.update_record!(source_user, target_user, amount)

          LendTransaction.create!(source_id: source_user.id, target_id: target_user.id, amount: amount)
        end

      rescue ActiveRecord::RecordInvalid => exception
        raise exception
      end
    end
  end
end