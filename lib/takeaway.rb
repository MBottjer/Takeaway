require "twilio-ruby"

class Takeaway 

  def initialize
    @menu = {number_1: 5, number_2: 4, number_3: 7, number_4: 9}
  end

  def menu
    @menu
  end

  def hour_from_now 
    time = Time.new
    time = time + (60*60)
    time.strftime('%H:%M')
  end

  def register_order(dishes, price)
      order_error unless correct_price?(dishes, price)
      send_sms("Thank you! Your order was placed and will be delivered before #{hour_from_now}")  
  end

  def order_error 
    raise ArgumentError, 'Sorry Sir/Madam, but it seems the total was incorrect. My sincerest apologies.'
  end

  def correct_price?(dishes, cost)
    price_of_dishes = dishes.values
    true_price = price_of_dishes.inject(0) { |memo, value| memo + value}
    return true if true_price == cost 
    false
  end

  def twilio_client
    @account_sid = 'AC2376f8d4fece2da91ad5d0745bf7526d'
    @auth_token = '172df3d52ee24575c91be814027b79d2'
    @twilio_client = Twilio::REST::Client.new(@account_sid, @auth_token)
  end

  def send_sms(message)
    message = twilio_client.account.sms.messages.create({:from => '+441282574009', :to => '+447788436628', :body => message})
  end



end