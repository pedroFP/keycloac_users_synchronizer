class Keycloak::Realm
  attr_reader :realm

  def initialize(realm)
    @realm = realm
  end

  def users
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = false # TODO: handle when envorionment is PRODUCTION
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Authorization'] = "Bearer #{Keycloak::AccessTokenGenerator.call}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  private

  def url
    base = ENV.fetch('KEYCLOAK_BASE_URL', 'http://localhost:8080')
    @url ||= URI("#{base}/admin/realms/#{realm}/users")
  end
end
