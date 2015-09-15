require 'sinatra'
require 'open-uri'
require 'sinatra/reloader'

set :port => 4646

# Monkeypatch OpenURI to allow http -> https redirection
module OpenURI
  def OpenURI.redirectable?(uri1, uri2)
    uri1.scheme.downcase == uri2.scheme.downcase ||
    (/\A(?:http|ftp)\z/i =~ uri1.scheme && /\A(?:http|ftp)\z/i =~ uri2.scheme) ||
    ( uri1.scheme.downcase == 'http' && uri2.scheme.downcase == 'https' )
  end
end

# Capture anything
get '/*' do
    url = request.url
    puts "Pass through for request " + request.url.to_s

  # Set the content type to whatever was requested
  content_type request.preferred_type.to_s

  open(url) do |content|
     content.read
  end
end


