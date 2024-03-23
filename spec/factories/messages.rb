# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  body       :string(255)
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_chat_id             (chat_id)
#  index_messages_on_number_and_chat_id  (number,chat_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#
FactoryBot.define do
  factory :message do
    number { 1 }
    chat { nil }
    body { "MyString" }
  end
end
