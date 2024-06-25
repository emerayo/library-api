# frozen_string_literal: true

module ApiHelper
  def auth_headers(user)
    sign_in(user)
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{user.jti}" }
  end
end
