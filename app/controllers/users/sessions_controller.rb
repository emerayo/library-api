# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include RackSessionFix

    respond_to :json

    private

    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    end

    # rubocop:disable Metrics/MethodLength
    def respond_to_on_destroy
      if current_user
        render json: {
          status: 200,
          message: 'logged out successfully'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
