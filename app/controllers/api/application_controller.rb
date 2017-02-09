module API
  class ApplicationController < ActionController::API
    def api_error(status, msg)
      render json: {msg: msg}, status: status
    end

    def render_422(msg = 'Invalid Parameters!')
      api_error(:unprocessable_entity, msg)
    end

    def format_errors(errors)
      errors.full_messages.join("\n")
    end

    def render_nothing
      head :no_content
    end
  end
end
