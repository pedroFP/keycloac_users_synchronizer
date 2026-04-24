class UserProducer
  attr_reader :payload, :key

  KAFKA_TOPIC = 'keycloak.users'.freeze

  def initialize(payload)
    @payload = payload
    @key = payload['id']
  end
  
  def produce
    Karafka.producer.produce_sync(topic: KAFKA_TOPIC, payload:, key:)
  end
end