#!/usr/bin/env ruby

require 'rss'
#require 'feed-normalizer'

blogs = [
  "http://foxtrot0304.hatenablog.com/rss"
]
blogs.each do |url|
  rss = RSS::Parser.parse(url)
  puts rss.channel.title
  puts rss.channel.link
  rss.channel.items.each do |a|
    puts a.pubDate
    puts a.title
    break
  end
end
