module API
  class TransactionsController < ApplicationController
    before_action :require_source_user!

    def create_lend_transaction
      target_user = User.find_by_id(params[:target_id])
      amount = params[:amount].to_i

      (render_422 && return) if target_user.nil? || amount <= 0 || @source_user == target_user

      begin
        LendTransaction.create_transaction!(@source_user, target_user, amount)
        render_nothing
      rescue ActiveRecord::RecordInvalid
        render_422('The amount exceeds the balance')
      end
    end

    private
    def require_source_user!
      @source_user = User.find_by_access_token(request.headers['X-API-Token'])
      if @source_user.nil? || @source_user.id.to_s != params[:source_id]
        render render_403 && return
      end
    end
  end

end