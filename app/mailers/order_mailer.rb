class OrderMailer < ApplicationMailer

  def send_confirmation(order)
    @order = order
    @contact = @order.contact
    mail to: @contact.email, subject: 'Order Confirmation'
  end

end
