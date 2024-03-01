class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_permitted
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_bad_request

  private

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def record_not_permitted
    render json: { error: 'Record not permitted' }, status: :unprocessable_entity
  end

  def handle_bad_request(exception)
    Rails.logger.error "Erro 400: #{exception.message}"
    render json: { error: "#{exception.message}" }, status: :bad_request
  end
end
