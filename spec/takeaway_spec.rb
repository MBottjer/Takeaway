require 'takeaway'

describe Takeaway do 

  let(:chinese_shop) {Takeaway.new}
  let(:twilio_client) {double :TwilioRESTClient}

  it 'should have a menu that contains multiple dishes' do
    expect(chinese_shop.menu).to eq :number_1=>5, :number_2=>4, :number_3=>7, :number_4=>9
  end

  it 'should show the price of a given dish on the menu' do 
    expect(chinese_shop.menu[:number_1]).to eq 5
  end

  it 'the shop must be able to calculate the total price of an order' do
    dishes = {number_1: 5, number_2: 4}
    cost = 9
    expect(chinese_shop.correct_price?(dishes, cost)).to be_true 
  end

  it 'the shop must be able to register orders' do 
    expect(chinese_shop).to receive(:send_sms).and_return('thanks')
    chinese_shop.register_order({number_1: 5, number_2: 4}, 9)
  end

  it 'can tell me what the time will be an hour later' do
    time = Time.new(1)
    expect(Time).to receive(:new).and_return(time)
    expect(chinese_shop.hour_from_now).to eq '01:00'
  end

  it 'the shop must raise an error if an order doesn\'t sum to the customers expectations' do 
    expect{chinese_shop.register_order({number_1: 2}, 3)}.to raise_error(ArgumentError, 'Sorry Sir/Madam, but it seems the total was incorrect. My sincerest apologies.')
  end

  it 'the takeaway shop has a client object to talk to twilio\'s servers' do 
    expect(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
    expect(chinese_shop.twilio_client).to be twilio_client
  end

  it 'can send an sms message' do 
    account = double :account
    sms = double :sms 
    messages = double :messages
    message = "please send this message!"
    expect(chinese_shop).to receive(:twilio_client).and_return twilio_client
    expect(twilio_client).to receive(:account).and_return account
    expect(account).to receive(:sms).and_return sms 
    expect(sms).to receive(:messages).and_return messages
    expect(messages).to receive(:create).and_return message
    chinese_shop.send_sms(message)
  end



end