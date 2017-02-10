module API
  class UsersController < ApplicationController
    before_action :require_user!, only: [:status]

    def create
      user = User.new(user_params)
      if user.save
        user.reload.asset.update(balance: params[:balance])
        render json: {user_id: user.id, access_token: user.access_token}
      else
        render_422(format_errors(user.errors))
      end
    end

    def status
      render json: record_to_json(@user.asset, [:balance, :amount_of_lend, :amount_of_borrow])
    end

    private
    def user_params
      params.permit(:password)
    end
  end
end