# == Schema Information
#
# Table name: gifts
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  description     :text
#  favorite        :boolean          default(FALSE)
#  gift_type       :string
#  image           :string
#  name            :string
#  price           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_gifts_on_organization_id  (organization_id)
#  index_gifts_on_user_id          (user_id)
#
require 'rails_helper'

RSpec.describe Gift, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
  end

  describe 'validation' do
    it { is_expected.to define_enum_for(:gift_type).with_values(Gift.gift_types).backed_by_column_of_type(:string) }
    
    context "when valid Factory gifts" do
      it "has a valid Role" do
        expect(build(:role)).to be_valid
      end
    end
  end
end
