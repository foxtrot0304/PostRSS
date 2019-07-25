#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'yaml'

require 'rss'
require 'feed-normalizer'
require 'open-uri'

require 'date'


def load_blogs
  File.read("blog.txt")
end

def load_url
  YAML.load_file("url.yaml")
end

def check_date?(last_updated)
  day = Date.today
  before_3day = day.prev_day(3)
  if last_updated.to_date > before_3day
    true;
  else
    false;
  end
end

def load_post_param(title,url,last_updated)
post = <<"EOS"
{
  "attachments":[
    {
      "fallback":"fallback",
      "pretext":"#{last_updated}",
      "color":"#7CFC00",
      "fields":[
        {
          "title":"#{title}",
          "value":"#{url}"
        }
      ]
    }
  ]
}
EOS
end

def slack_url
  "https://hooks.slack.com/services/#{load_url["url"]}"
end

uri = URI.parse(slack_url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri)
req["Content-Type"] = "application/json"

load_blogs.each_line do |url|
  atom = FeedNormalizer::FeedNormalizer.parse(open(url.chomp))
  req.body = load_post_param(atom.entries.first.title,atom.entries.first.url,atom.last_updated)
  req["Content-Length"] = req.body.length.to_s
  result = http.request(req) if check_date?(atom.last_updated)
end
