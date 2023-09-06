require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    base_url = 'https://api.giphy.com/v1/gifs'
    api_key = ENV['GIPHY_AUTH_TOKEN']

    stub_request(:get, "#{base_url}/search?api_key=#{api_key}&limit=1&q=")
      .to_return(
        status: 200,
        body: {
          data: [
            {
              url: 'https://example.com/gif_url'
            }
          ]
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      )

      stub_request(:get, "#{base_url}/search?api_key=#{api_key}&limit=1&q=New%20Team")
      .to_return(
        status: 200,
        body: {
          data: [
            {
              url: 'https://example.com/gif_url'
            }
          ]
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      )

  end
end
