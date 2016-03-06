require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { build :review }
  subject { review }

  it { should respond_to(:title) }
  it { should respond_to(:body) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:product_id) }
  it { should validate_presence_of(:rating) }

  it { should belong_to(:product) }
  it { should belong_to(:user) }

  it { should have_many(:images) }

  it { should validate_numericality_of(:rating).only_integer
                  .is_greater_than_or_equal_to(0)
                  .is_less_than_or_equal_to(10) }

end
