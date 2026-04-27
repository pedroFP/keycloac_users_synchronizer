class SyncKeycloakUsers
  def self.call
    users_count = Keycloak::User.count
    users_per_page = 100
    number_of_pages = (users_count.to_f / users_per_page).ceil # round up
    page = 0

    while page <= (number_of_pages - 1)
      Keycloak::User.page(page).limit(users_per_page).each do |user|
        UserProducer.new(user).produce
      end
      page += 1
    end
  end
end