require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image) { build :image }
  subject { image }


  it { should respond_to(:file) }

  it { should validate_presence_of(:imageable_id) }
  it { should validate_presence_of(:imageable_type) }

  it { should belong_to(:imageable) }

  it { should validate_inclusion_of(:imageable_type).in_array(Image::IMAGEABLE_TYPES) }

  it 'has file image and thumb urls' do
    expect(image.file.url).not_to be_nil
    expect(image.file.thumb.url).not_to be_nil
  end


end
