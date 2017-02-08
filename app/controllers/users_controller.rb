class UsersController < ApplicationController
  def create
    if user = User.create(money: params.delete(:money){0})
      render json: {user_id: user.id}
    else
      render_422(format_errors(user.errors))
    end
  end
end