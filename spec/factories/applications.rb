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
FactoryBot.define do
  factory :application do
    sequence(:name) { |n| "#{FFaker::Lorem.word} #{n}" }
    sequence(:token) { SecureRandom.uuid }
    chats_count { 1 }
  end
end
