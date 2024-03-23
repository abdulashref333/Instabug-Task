class Chat::ChatCreatoinWorkerJob
  include Sidekiq::Worker

  sidekiq_options queue: :instabug_task_development_chats

  def perform(application_id, next_chat_number)
    chat = Chat.create!(application_id: application_id, number: next_chat_number)
  end
end
