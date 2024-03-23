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
class Application < ApplicationRecord
  # Validations
  validates :token, uniqueness: true
  validates :name, presence: true

  # Relations
  has_many :chats, dependent: :destroy
end
