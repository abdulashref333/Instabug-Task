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
require 'rails_helper'

RSpec.describe Message, type: :model do
  before(:all) { Message.destroy_all }
  before(:all) do
    Message.skip_callback(:commit, :after, :schedule_indexing)
    Message.skip_callback(:commit, :after, :schedule_reindexing)
  end

  after(:all) do
      Message.set_callback(:commit, :after, :schedule_indexing)
      Message.set_callback(:commit, :after, :schedule_reindexing)
  end

  subject { create(:message) }

  describe 'validations' do
    it { should be_valid }
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).ignoring_case_sensitivity.scoped_to(:chat_id) }
  end

  describe 'associations' do
    it { should belong_to(:chat) }
  end
end
