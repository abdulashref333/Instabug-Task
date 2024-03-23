# == Schema Information
#
# Table name: applications
#
#  id          :bigint           not null, primary key
#  chats_count :integer
#  name        :string(255)
#  token       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_applications_on_token  (token) UNIQUE
#
require 'rails_helper'

RSpec.describe Application, type: :model do
  before(:all) { Application.destroy_all }
  subject { build(:application) }

  describe 'validations' do
    it { should be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:token) }
    it { should validate_uniqueness_of(:token).ignoring_case_sensitivity }

    it { should have_many(:chats) }
  end
end
