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
  include JsonWithoutId
  include Searchable

  # Validations
  validates :chat_id, presence: true
  validates :number, uniqueness: { scope: :chat_id }, presence: true
  validates :body, presence: true

  # Relations
  belongs_to :chat, counter_cache: :messages_count

  # Callbacks
  after_commit :schedule_indexing, on: :create
  after_commit :schedule_reindexing, on: :update

  def self.search(query, chat_id)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              { term: { chat_id: chat_id } },
              { match: { body: { query: query, operator: "and" } } }
            ]
          }
        }
      }
    )
  end

  def as_indexed_json(options = {})
    self.as_json(only: [:body, :chat_id])
  end
  private

  def schedule_indexing
    Search::MesseageIndexerJob.perform_async(:index, id)
  end

  def schedule_reindexing
    Search::MesseageIndexerJob.perform_async(:update, id)
  end

  
end
