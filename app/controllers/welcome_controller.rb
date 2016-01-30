require 'open_weather'

class WelcomeController < ApplicationController
  def index
    puts '-' * 10
    ap params
    puts '-' * 10
    options = { units: "imperial", APPID: ENV["API_KEY"] }
    weather_report = OpenWeather::Current.city("#{params["FromCity"]}, #{params["FromState"]}", options)
    ap weather_report
    weather_description = weather_report["weather"][0]["description"]
    temp_min = weather_report["main"]["temp_min"]
    temp_max  = weather_report["main"]["temp_max"]
    ap weather_report

    user = User.where(phone: params["Caller"]).first

    pacific_time = Time.now.dst? ? 'pacific daylight time' : 'pacific standard time'

    response = Twilio::TwiML::Response.new do |r|
      if user
        r.Say "Hello #{user.name}, the current time is #{Time.now.strftime("%I:%M:%S %P")} #{pacific_time}.", voice: 'alice'
      else
        r.Say "Hello, the current time is #{Time.now.strftime("%I:%M:%S %P")} #{pacific_time}.", voice: 'alice'
      end
      r.Say "The current weather report for #{params["FromCity"]} is #{weather_description}, with a high temperature of #{temp_max} and a low of #{temp_min} degrees Fahrenheit.", voice: 'alice'
    end

    render xml: response.text
  end
end
