class Debt < ActiveRecord::Base
  belongs_to :debtor, class_name: 'User', foreign_key: 'debtor_id'
  belongs_to :debtee, class_name: 'User', foreign_key: 'debtee_id'

  validates :amount, numericality: {greater_than_or_equal_to: 0}

  # this method will update debt record
  # if record's debtee is not param's debtee and record's debtee is less than param's amount
  # then debt relation will be reversed
  # amount must be positive
  def update_record!(debtee, debtor, amount)
    raise ActiveRecord::RecordInvalid if amount < 0
    return if amount == 0
    begin
      if self.debtee == debtee && self.debtor == debtor
        # if a loan
        self.update!(amount: self.amount+amount)
      elsif amount < self.amount
        # it's payback and not all payback
        self.update!(amount: self.amount - amount)
      elsif amount > self.amount
        # if it' payback and amount is greater than debt, it will exchange user's position
        self.update!(debtee_id: debtee.id, debtor_id: debtor.id, amount: amount - self.amount)
      else
        # it' payback and exactly payback all
        self.destroy!
      end
    rescue ActiveRecord::RecordInvalid => exception
      raise exception
    end
  end

  def debt_between(user1, user2)
    if debtor == user1 && debtee == user2
      -1* amount
    elsif debtor == user2 && debtee == user1
      amount
    else
      0
    end
  end

  class << self
    # this method check the debt between user1 and user2
    # return value:
    # 1. if the return value is positive, user2 owes user1
    # 2. if the return value is negative, user1 owes user2
    def query(user1, user2)
      return nil if user1.nil? || user2.nil?
      debt = Debt.find_record(user1, user2)
      return 0 unless debt
      debt.debt_between(user1, user2)
    end

    def find_or_create_record(user1, user2)
      debt = Debt.find_record(user1, user2)
      debt = Debt.create!(debtee_id: user1.id, debtor_id: user2.id, amount: 0) unless debt
      debt
    end
    def find_record(user1, user2)
      Debt.where('debtor_id = :user1 AND debtee_id = :user2 OR debtor_id = :user2 AND debtee_id = :user1', {user1: user1.id, user2: user2.id})
          .first
    end
  end
end