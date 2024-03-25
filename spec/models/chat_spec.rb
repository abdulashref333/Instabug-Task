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
require 'rails_helper'

RSpec.describe Chat, type: :model do
  before(:all) { Chat.destroy_all }
  subject { create(:chat) }

  describe 'validations' do
    it { should be_valid }
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number).ignoring_case_sensitivity.scoped_to(:application_id) }
  end

  describe 'associations' do
    it { should belong_to(:application) }
    it { should have_many(:messages) }
 end
end
