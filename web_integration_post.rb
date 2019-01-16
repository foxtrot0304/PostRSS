#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'yaml'

def load_url
  YAML.load_file("url.yaml")
end

def load_post_param
  File.open("param.json") do |f|
    JSON.load(f)
  end
end

def slack_url
  "https://hooks.slack.com/services/#{load_url["url"]}"
end

uri = URI.parse(slack_url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri)
req["Content-Type"] = "application/json"
req["Content-Length"] = load_post_param.length.to_s
# json形式のファイルを読み込んだ時点でhashになるので、jsonに再変換
req.body = load_post_param.to_json

http.request(req)
