# Nanoc::Mailchimp

[Nanoc](https://nanoc.ws) content source from Mailchimp API. Build your own public archive of mailing campaigns.

## Usage

Add to `Gemfile` in your nanoc project:

```ruby
gem "nanoc-mailchimp"
```

Then tell nanoc to load it in `lib/default.rb`:

```ruby
require "nanoc/mailchimp"
```

At last, enable mailchimp data source in `nanoc.yaml`:

```yaml
data_sources:
  - type: mailchimp
    items_root: /campaigns                         # the root where items should be mounted
    api_key: secret123                             # mailchimp api key                                                (default: nil)
    concurrency: 10                                # how many threads to spawn to fetch data                          (default: 5)
```

## Status

[![build status](https://github.com/pawelpacana/nanoc-mailchimp/workflows/test/badge.svg)](https://github.com/pawelpacana/nanoc-mailchimp/actions)
[![gem version](https://badge.fury.io/rb/nanoc-mailchimp.svg)](https://badge.fury.io/rb/nanoc-mailchimp)
