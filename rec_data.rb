#!/usr/bin/env ruby

require 'httparty'

# Ruby convenience class to access Dept of Interior's RIDB
# API. Details of the API can be found at http://usda.github.io/RIDB/
#
# Get your API key at https://ridb-dev.nsitellc.com/?action=register
#
# Usage:
#       key = ENV['API_KEY']
#       api = RecData.new key
#       http_response = api.organizations
#
class RecData
  include HTTParty
  base_uri 'https://ridb-dev.nsitellc.com'

  def initialize(key)
    @options = { headers: {'apikey' => key} }
  end

  def organizations
    self.class.get("/api/v1/organizations", @options)
  end

end


if __FILE__ == $0
  require 'minitest/autorun'

  # Set API_KEY in environment variable before running tests. For
  # example:
  #
  # API_KEY=01234567890123456789012345678901 ruby rec_data.rb
  #
  class Test < Minitest::Test
    def setup
      key = ENV['API_KEY']
      refute_nil key, '"API_KEY" not found in environment'

      @api = RecData.new key
    end

    def test_orgs
      response = @api.organizations
      obj = JSON.parse response.body

      assert_equal ['RECDATA', 'METADATA'], obj.keys
      assert_equal 32, obj['RECDATA'].size
    end
  end
end
