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
class Message < ApplicationRecord
  # Validations
  validates :chat_id, presence: true
  validates :number, uniqueness: { scope: :chat_id }, presence: true

  # Relations
  belongs_to :chat, counter_cache: :messages_count
end
