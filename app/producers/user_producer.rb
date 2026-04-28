class UserProducer
  attr_reader :payload, :key

  KAFKA_TOPIC = 'keycloak.users'.freeze

  def initialize(user)
    @payload = user.to_h
    @key = user.keycloak_id
  end

  def produce
    Karafka.producer.produce_sync(topic: KAFKA_TOPIC, payload: @payload.to_json, key: @key)
  end
end
