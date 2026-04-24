# Get users from Keycloak
#
# @example
#   users = Keycloak::User.all
#   users = Keycloak::User.l

class Keycloak::User
  def self.url
    URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users")
  end

  def self.all
    call
  end

  def self.limit(number)
    url = self.url

    define_singleton_method(:url) do
      url.query = URI.encode_www_form(max: number)
      url
    end

    call
  end

  def self.call
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = false # TODO: handle when envorionment is PRODUCTION
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Authorization'] = "Bearer #{Keycloak::AccessTokenGenerator.call}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end
end

