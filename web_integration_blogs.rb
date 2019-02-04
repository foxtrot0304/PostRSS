#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'yaml'

require 'rss'
require 'feed-normalizer'
require 'open-uri'


def load_blogs
  File.read("blog.txt")
end

def get_new_article
load_blogs.each_line do |url|
  atom = FeedNormalizer::FeedNormalizer.parse(open(url.chomp))
  puts atom.entries.first.title
  puts atom.entries.first.url
  puts atom.last_updated
end
end

def load_url
  YAML.load_file("url.yaml")
end

def load_post_param(title,url)
post = <<"EOS"
{
  "attachments":[
    {
      "fallback":"fallback",
      "pretext":"attachments",
      "color":"#D00001",
      "fields":[
        {
          "title":"hello",
          "value":"world"
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
  req.body = load_post_param(atom.entries.first.title,atom.entries.first.url)
  req["Content-Length"] = req.body.length.to_s
  p req.body
  result = http.request(req)
  p result
end
