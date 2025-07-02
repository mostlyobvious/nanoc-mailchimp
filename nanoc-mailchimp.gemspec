# frozen_string_literal: true

require_relative "lib/nanoc/mailchimp/version"

Gem::Specification.new do |spec|
  spec.name = "nanoc-mailchimp"
  spec.version = Nanoc::Mailchimp::VERSION
  spec.summary = "Nanoc content source from Mailchimp campaigns"
  spec.description = <<~DESC
    Nanoc content source from Mailchimp API. Build your own public archive of mailing campaigns.
  DESC
  spec.authors = ["Paweł Pacana"]
  spec.license = "MIT"
  spec.email = ["pawel.pacana@gmail.com"]
  spec.homepage = "https://github.com/pawelpacana/nanoc-mailchimp"
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/pawelpacana/nanoc-mailchimp",
    "changelog_uri" =>
      "https://github.com/pawelpacana/nanoc-mailchimp/releases",
    "bug_tracker_uri" => "https://github.com/pawelpacana/nanoc-mailchimp/issues"
  }
  spec.files = Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = Dir["README.md", "LICENSE.txt"]

  spec.add_dependency "nanoc", "~> 4.0"
  spec.add_dependency "MailchimpMarketing", ">= 3.0.80", "< 4.0"
  spec.add_dependency "concurrent-ruby", ">= 1.1.6", "< 2.0"
end
