require 'sinatra'
require 'redis'

set :bind, '0.0.0.0'
set :port, 8080
 
redis_w = Redis.new(:host => "shorturl-m.tfa0rf.0001.apse1.cache.amazonaws.com", :port=> 6379)
redis_r = Redis.new(:host => "shorturl-g.tfa0rf.ng.0001.apse1.cache.amazonaws.com", :port=> 6379)
 
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
 
  def random_string(length)
    rand(36**length).to_s(36)
  end
end
 
get '/' do
  erb :index
end
 
post '/' do
  if params[:url] and not params[:url].empty?
    @shortcode = random_string 5
    redis_w.setnx "links:#{@shortcode}", params[:url]
  end
  erb :index
end
 
get '/:shortcode' do
  @url = redis_r.get "links:#{params[:shortcode]}"
  redirect "http://"+@url 
end
