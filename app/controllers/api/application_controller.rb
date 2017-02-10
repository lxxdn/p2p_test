module API
  class ApplicationController < ActionController::API
    def api_error(status, msg)
      render json: {msg: msg}, status: status
    end

    def render_422(msg = 'Invalid Parameters!')
      api_error(:unprocessable_entity, msg)
    end

    def render_403(msg = 'Please user the correct access token')
      api_error(:forbidden, msg)
    end

    def format_errors(errors)
      errors.full_messages.join("\n")
    end

    def render_nothing
      head :no_content
    end

    def require_user!
      @user = User.find_by_access_token(request.headers['X-API-Token'])
      user_id = params[:source_id] || params[:user_id]
      if @user.nil? || @user.id.to_s != user_id
        render render_403 && return
      end
    end
    alias_method :require_source_user!, :require_user!

    def record_to_json(record, attributes)
      record.attributes.slice(*attributes.map(&:to_s))
    end
  end
end
