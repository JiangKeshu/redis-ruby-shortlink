require 'sinatra'
require 'redis'

set :bind, '0.0.0.0'
set :port, 8080

redis_endpoint_w = "shorturl-m.tfa0rf.0001.apse1.cache.amazonaws.com"
redis_endpoint_r = "shorturl-g.tfa0rf.ng.0001.apse1.cache.amazonaws.com"

redis_w = Redis.new(:host => redis_endpoint_w, :port=> 6379)
 
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
  redis_r = Redis.new(:host => redis_endpoint_r, :port=> 6379)
  @url = redis_r.get "links:#{params[:shortcode]}"
  redirect "http://"+@url 
end
