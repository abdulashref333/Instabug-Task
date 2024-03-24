class Chat::ChatCreatoinWorkerJob
  include Sidekiq::Worker

  sidekiq_options queue: :instabug_task_development_chats

  def perform(cache_key, application_id, next_chat_number)
    begin
      puts "#################### Chat creation started ####################"
      chat = Chat.create!(application_id: application_id, number: next_chat_number)
    rescue => e
      puts "#################### Chat creation failed ####################"
      puts e
      REDIS.decr(cache_key)
    end
  end
end
