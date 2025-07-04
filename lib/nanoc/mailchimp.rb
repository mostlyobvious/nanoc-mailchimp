require "nanoc"
require "concurrent-ruby"
require "MailchimpMarketing"

module Nanoc
  module Mailchimp
    class Source < Nanoc::DataSource
      Campaign =
        Data.define(:id, :title, :subject_line, :send_time, :plain_text, :html)

      identifier :mailchimp

      def items
        @items ||=
          begin
            campaigns
              .sort_by { |campaign| campaign.send_time }
              .reverse
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
              campaigns.settings.subject_line
            ]
          )
          .fetch("campaigns")
          .reverse
          .take(limit)
          .each do |campaign|
            pool.post do
              content = client.campaigns.get_content(id = campaign.fetch("id"))

              items << Campaign.new(
                id: id,
                title: campaign.dig("settings", "title"),
                subject_line: campaign.dig("settings", "subject_line"),
                send_time: campaign.fetch("send_time"),
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

      def limit
        @config[:limit] || 1000
      end
    end
  end
end
