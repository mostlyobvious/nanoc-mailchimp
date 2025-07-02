require_relative "test_helper"

module Nanoc
  module Mailchimp
    class SourceTest < Minitest::Test
      def site_config
        Nanoc::Core::Configuration.new(hash: {}, dir: "/dummy")
      end
    end
  end
end
