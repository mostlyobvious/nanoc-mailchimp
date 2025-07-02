require "nanoc"
require "concurrent-ruby"
require "MailchimpMarketing"

module Nanoc
  module Mailchimp
    class Source < Nanoc::DataSource
      Campaign = Data.define(:id, :title, :send_time, :plain_text, :html)

      identifier :mailchimp

      def items
        @items ||=
          begin
            campaigns
              .sort_by { |campaign| campaign.send_time }
              .map do |campaign|
                new_item(
                  "",
                  campaign.to_h,
                  Nanoc::Identifier.new("/campaigns/#{campaign.id}")
                )
              end
          end
      end

      def client
        MailchimpMarketing::Client.new(api_key: api_key)
      end

      def campaigns
        pool = Concurrent::FixedThreadPool.new(concurrency)
        items = Concurrent::Array.new
        client
          .campaigns
          .list(
            count: 1000,
            status: "sent",
            fields: %i[
              campaigns.id
              campaigns.send_time
              campaigns.settings.title
            ]
          )
          .fetch("campaigns")
          .each do |campaign|
            pool.post do
              content =
                client.campaigns.get_content(
                  id = campaign.dig("campaigns", "id")
                )

              items << Campaign.new(
                id: id,
                title: campaign.dig("campaigns", "settings", "title"),
                send_time: campaign.dig("campaigns", "send_time"),
                plain_text: content.fetch("plain_text"),
                html: content.fetch("html")
              )
            end
          end
        pool.shutdown
        pool.wait_for_termination
        items
      end

      def concurrency
        @config[:concurrency] || 5
      end

      def api_key
        @config[:api_key]
      end
    end
  end
end
