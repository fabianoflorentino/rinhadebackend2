class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_permitted

  private

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def record_not_permitted
    render json: { error: 'Record not permitted' }, status: :unprocessable_entity
  end
end
