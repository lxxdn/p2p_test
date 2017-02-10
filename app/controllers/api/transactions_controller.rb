module API
  class TransactionsController < ApplicationController
    before_action :require_source_user!

    def create_lend_transaction
      create_transaction do |target_user, amount|
        begin
          LendTransaction.create_transaction!(@user, target_user, amount)
          render_nothing
        rescue ActiveRecord::RecordInvalid => e
          render_422(e.message)
        end
      end
    end


    def create_payback_transaction
      create_transaction do |target_user, amount|
        begin
          PaybackTransaction.create_transaction!(@user, target_user, amount)
          render_nothing
        rescue ActiveRecord::RecordInvalid => e
          render_422(e.message)
        rescue RuntimeError => e
          render_422(e.message)
        end
      end
    end


    def check_between
      user2 = User.find_by_id(params[:user2_id])
      result = Debt.query(@user, user2)
      if result
        render json: {debt: result}
      else
        render_422
      end
    end

    private
    def create_transaction(&block)
      target_user = User.find_by_id(params[:target_id])
      amount = params[:amount].to_i

      (render_422 && return) if target_user.nil? || amount <= 0 || @user == target_user

      yield(target_user, amount) if block_given?
    end
  end
end