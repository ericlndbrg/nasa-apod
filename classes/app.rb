# frozen_string_literal: true

class App
  require 'date'
  require 'net/http'
  require 'json'

  attr_reader :date

  def initialize
    self.date = ARGF.argv.empty? ? Date.today.to_s : valid_date_param(ARGF.argv.first)
  end

  def run
    raise_if_image_exists
    fetch_apod_metadata
    validate_apod_metadata
    download_apod
  end

  private

  attr_writer :date
  attr_accessor :apod_metadata

  def valid_date_param(user_input)
    # required date format: YYY-MM-DD
    unless user_input.match?(/\d{4}-\d{2}-\d{2}/)
      raise "#{user_input} is formatted incorrectly, use YYYY-MM-DD format instead"
    end

    # date needs to be valid, raises an exception otherwise
    Date.strptime(user_input, '%Y-%m-%d')

    # date must be within APOD date range
    soonest_apod_date = Date.new(1995, 6, 16)
    latest_apod_date = Date.today
    unless (soonest_apod_date..latest_apod_date).include?(Date.parse(user_input))
      raise "#{user_input} is an invalid APOD date, choose a date between #{soonest_apod_date.to_s} and #{latest_apod_date.to_s} inclusive"
    end

    user_input
  end

  def raise_if_image_exists
    if Dir.children('images').detect { |filename| filename.start_with?(date) }
      raise "APOD for #{date} has already been downloaded"
    end
  end

  def fetch_apod_metadata
    api_uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['NASA_APOD_API_KEY']}&date=#{date}")
    self.apod_metadata = JSON.parse(Net::HTTP.get(api_uri))
  end

  def validate_apod_metadata
    required_keys = ['date', 'hdurl', 'media_type', 'title']

    unless required_keys.map { |required_key| apod_metadata.has_key?(required_key) }.all?
      raise 'some required keys were not present in NASA\'s response'
    end

    raise "APOD for #{date} is not an image" unless apod_metadata['media_type'] == 'image'
  end

  def download_apod
    filename = "#{date} #{apod_metadata['title']}#{File.extname(apod_metadata['hdurl'])}"
    img_uri = URI(apod_metadata['hdurl'])

    Net::HTTP.start(img_uri.hostname, use_ssl: true) do |http|
      get_request_obj = Net::HTTP::Get.new(img_uri)
      http.request(get_request_obj) do |get_response_obj|
        File.open("images/#{filename}", 'w') do |file|
          get_response_obj.read_body do |chunk|
            file.write(chunk)
          end
          file.flush
        end
      end
    end
  end
end
