# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_response_format

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied, with: :unauthorized

  private

  def not_found
    render json: { error: 'not-found' }, status: :not_found
  end

  def unauthorized
    render json: { error: 'not authorized to perform this action' }, status: :unauthorized
  end

  def set_response_format
    request.format = :json
  end
end
