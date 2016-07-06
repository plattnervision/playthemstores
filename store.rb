
require 'httparty'
require 'json'
require 'faker'
require_relative '../config/envirovar.rb'

class ApiCall
  attr_accessor :response, :api, :usx
  def initialize(api)
    @api = api
    @usx = datacenter(api)
  end

  def datacenter(api)
    if api.length == 37
      api[-4..-1]
    else
      api[-3..-1]
    end
  end

  def fire(endpoint, json)
    auth = { :username => "user", :password => api }
    HTTParty.post("https://#{usx}.api.mailchimp.com/3.0#{endpoint}", :body => json, :verify => false, :basic_auth => auth)
  end
end

class List
  attr_accessor :list_id, :lists_info, :api
  def initialize(args)
    @api = args[:api]
    @lists_info = list_creater
  end

  def set_list_id #saves the list id from your newly created list
    list_id['id']
  end

  def random_values
     {
       :name => Faker::Lorem.word,
       :contact => {
          :company =>  Faker::Company.name,
          :address1 => Faker::Address.street_address,
          :city => Faker::Address.city,
          :state => Faker::Address.state,
          :zip => Faker::Address.zip_code,
          :country => Faker::Address.country_code
        },
        :permission_reminder => Faker::Lorem.sentence(3),
        :campaign_defaults => {
          :from_name => Faker::Name.name,
          :from_email => "examples@mailchimp.com",
          :subject => Faker::Lorem.sentence,
          :language => Faker::Address.country_code
        },
        :email_type_option => false
      }.to_json
  end

  def list_creater
    api.fire('/lists', random_values)
  end

end




 a = List.new(:api => ApiCall.new(@apikey))
