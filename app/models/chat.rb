# == Schema Information
#
# Table name: chats
#
#  id             :bigint           not null, primary key
#  messages_count :integer
#  number         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :bigint           not null
#
# Indexes
#
#  index_chats_on_application_id             (application_id)
#  index_chats_on_number_and_application_id  (number,application_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (application_id => applications.id)
#
class Chat < ApplicationRecord
  include JsonWithoutId

  # Validations
  validates :application_id, presence: true
  validates :number, uniqueness: { scope: :application_id }, presence: true

  # Relations
  belongs_to :application
  has_many :messages

  # Callbacks
  after_commit :update_chats_count, on: :create

  # Methods
  def self.get_cache_chats_number_key(application_id)
    "next_chat_number_for_#{application_id}"
  end

  private
  def update_chats_count
    application.increment!(:chats_count)
  end
end
