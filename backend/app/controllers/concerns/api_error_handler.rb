module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_internal_server_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActionController::RoutingError, with: :handle_routing_error
  end

  private
  def handle_internal_server_error(error)
    render_error(:internal_server_error, error)
  end

  def handle_record_invalid(error)
    render_error(:unprocessable_entity, error, error.record.errors)
  end

  def handle_record_not_found(error)
    render_error(:not_found, error)
  end

  def render_error(status, error, details = nil)
    code, name = code_name_by_status(status)
    response = {
      status: code,
      error: name,
      exception: {
        class: error.class.to_s,
        message: error.message
      }
    }
    response[:details] = details if details

    render json: response, status: status
  end

  def code_name_by_status(status)
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    name = Rack::Utils::HTTP_STATUS_CODES[code]
    [code, name]
  end

  def handle_routing_error
    response = {
      status: 500,
      error: 'RoutingError',
      exception: {
        class: 'ActionController::RoutingError',
        message: 'Invalid api route'
      }
    }

    render json: response, status: 500
  end
end
