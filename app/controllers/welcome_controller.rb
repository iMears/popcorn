class WelcomeController < ApplicationController
  def index

    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hello, the time is #{Time.now.strftime("%I:%M:%S %P")}", voice: 'alice'
    end

    render xml: response.text
  end
end
