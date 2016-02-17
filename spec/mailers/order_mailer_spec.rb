require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe '.send_confirmation' do
    before(:each) do
      @user = create :user
      @order = create :order, user: @user

      @order_mailer = OrderMailer.send_confirmation(@order)
    end

    it 'should be set to be delivered to the user from the order passed in' do
      expect(@order_mailer).to deliver_to(@user.email)
    end

    it 'should be set to be send from from@example.com' do
      expect(@order_mailer).to deliver_from('from@example.com')
    end

    it "should contain the user's message in the mail body" do
      expect(@order_mailer).to have_body_text(/Order: ##{@order.id}/)
    end

    it 'should have the correct subject' do
      expect(@order_mailer).to have_subject(/Order Confirmation/)
    end

    it 'should have the product positions count' do
      expect(@order_mailer).to have_body_text(/You ordered #{@order.line_items.count} product positions:/)
    end
  end

end
