require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GiphyService, type: :service do
  describe '.get_gif' do
    let(:team_name) { 'Sample Team' }

    context 'when the Giphy API returns a valid response' do
      before do
        api_key = ENV['GIPHY_AUTH_TOKEN']
        stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
          .with(
            query: {
              api_key: api_key,
              q: team_name,
              limit: 1
            }
          )
          .to_return(
            status: 200,
            body: {
              data: [
                {
                  'url' => 'https://example.com/sample.gif'
                }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        allow(ENV).to receive(:[]).with('GIPHY_AUTH_TOKEN').and_return(api_key)
      end

      it 'returns the URL of the first GIF' do
        gif_url = GiphyService.get_gif(team_name)
        expect(gif_url).to eq('https://example.com/sample.gif')
      end
    end

    context 'when the Giphy API returns an error response' do
      before do
        api_key = ENV['GIPHY_AUTH_TOKEN']
        stub_request(:get, 'https://api.giphy.com/v1/gifs/search')
          .with(
            query: {
              api_key: api_key,
              q: team_name,
              limit: 1
            }
          )
          .to_return(
            status: 500,
            body: { error: 'Internal Server Error' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        allow(ENV).to receive(:[]).with('GIPHY_AUTH_TOKEN').and_return(api_key)
      end

      it 'returns an empty string' do
        gif_url = GiphyService.get_gif(team_name)
        expect(gif_url).to eq('')
      end
    end
  end
end
