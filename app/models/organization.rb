# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  logo          :string
#  monthly_point :integer          default(10)
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_organizations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Organization < ApplicationRecord
  has_many :roles
  belongs_to :user
  has_many :users, through: :roles

  validates :name, presence: true
  validates :monthly_point, numericality: { only_integer: true }

  after_commit :add_role
  after_create :send_mail_to_superadmin

  private

  def add_role
    self.roles.create(role: :admin, user_id: user_id)
  end 

  def send_mail_to_superadmin
    SuperadminMailer.superadmin_notification(self).deliver_now
  end
end
