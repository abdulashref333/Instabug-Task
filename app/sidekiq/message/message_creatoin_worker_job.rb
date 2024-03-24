class Message::MessageCreatoinWorkerJob
  include Sidekiq::Worker

  sidekiq_options queue: :instabug_task_development_messages

  def perform(cache_key, chat_id, next_message_number, body)
    begin
      puts "#################### Message creation started ####################"
      Message.create!(chat_id:, number: next_message_number, body:)
    rescue => e
      puts "#################### Message creation failed ####################"
      puts e
      REDIS.decr(cache_key)
    end
  end
end
