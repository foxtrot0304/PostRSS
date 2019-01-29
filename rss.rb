#!/usr/bin/env ruby

require 'rss'
require 'feed-normalizer'
require 'open-uri'


def load_blogs
  File.read("blog.txt")
end

load_blogs.each_line do |url|
  atom = FeedNormalizer::FeedNormalizer.parse(open(url.chomp))
  puts atom.entries.first.title
  puts atom.entries.first.url
  puts atom.last_updated
end
