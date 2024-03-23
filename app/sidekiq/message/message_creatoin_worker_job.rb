class Message::MessageCreatoinWorkerJob
  include Sidekiq::Worker

  sidekiq_options queue: :instabug_task_development_messages

  def perform(chat_id, next_chat_number, body)
    Message.create!(chat_id:, number: next_chat_number, body:)
  end
end
