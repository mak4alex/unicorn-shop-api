require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { build :category }
  subject { category }

  it { should validate_presence_of :title }
  it { should validate_presence_of :shop }

  it { should validate_uniqueness_of(:title).case_insensitive }

  it { should validate_length_of(:title).is_at_least(3).is_at_most(32) }
  it { should validate_length_of(:description).is_at_least(16).is_at_most(255) }

  it { should respond_to(:description) }

  it { should belong_to(:parent) }
  it { should belong_to(:shop) }

  it { should have_many(:subcategories) }
  it { should have_many(:products) }


  describe '.subcategories' do
    let(:category_with_subcategories) { create :category_with_subcategories, count: 3 }
    subject { category_with_subcategories }

    it { expect(category_with_subcategories.subcategories).to have_exactly(3).items }

  end

end
