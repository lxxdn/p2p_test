module API
  class TransactionsController < ApplicationController
    before_action :require_source_user!

    def create_borrow_transaction
      target_user = User.find_by_id(params[:target])
      amount = params[:amount].to_i

      (render_422 && return) if @source_user.nil?  || target_user.nil? || amount <= 0 || @source_user == target_user

      begin
        BorrowTransaction.create_transaction!(@source_user, target_user, amount)
        render_nothing
      rescue ActiveRecord::RecordInvalid
        render_422('The amount exceeds the balance')
      end
    end

    private
    def require_source_user!
      unless @source_user = User.find_by_access_token(params[:source_access_token])
        render render_403 && return
      end
    end
  end

end