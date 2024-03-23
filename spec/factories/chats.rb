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
FactoryBot.define do
  factory :chat do
    number { 1 }
    application { nil }
    messages_count { 1 }
  end
end
