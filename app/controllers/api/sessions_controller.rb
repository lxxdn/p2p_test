module API
  class SessionsController < ApplicationController
    def create
      user = User.find(params[:id])
      if user.authenticate(params[:password])
        render json: {access_token: user.access_token}
      else
        render_422('wrong user id or password')
      end
    end
  end
end