# == Schema Information
#
# Table name: offers
#
#  id         :integer          not null, primary key
#  userID     :integer
#  fullname   :string(255)
#  message    :text
#  userPic    :binary
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
