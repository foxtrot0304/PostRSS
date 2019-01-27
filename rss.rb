#!/usr/bin/env ruby

require 'rss'
require 'feed-normalizer'
require 'open-uri'

blogs = [
  "http://foxtrot0304.hatenablog.com/rss",
]

blogs.each do |url|
  atom = FeedNormalizer::FeedNormalizer.parse(open(url))
  puts atom.entries.first.title
  puts atom.entries.first.url
  puts atom.last_updated
end
