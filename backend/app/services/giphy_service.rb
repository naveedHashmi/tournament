# frozen_string_literal: true

class GiphyService
  include HTTParty

  def self.get_gif(team_name)
    base_url = 'https://api.giphy.com/v1/gifs/search'
    api_key = ENV['GIPHY_AUTH_TOKEN']


    response = HTTParty.get(base_url, query: {
      api_key: api_key,
      q: team_name,
      limit: 1
    })

    if response.success?
      data = JSON.parse(response.body)

      return data['data'].first['url']
    else
      ''
    end
  end
end
