require 'sinatra'
require 'json'
require 'sinatra/cross_origin'
require 'active_support/all'

set :port, 7100

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] =
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control,'\
    'Accept'
end

Tilt.register Tilt::ERBTemplate, 'html.erb'

text = 'no text added'

helpers do
  def safe(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  render 'html.erb', :index
end

get '/result' do
  render 'html.erb', :result, {}, text: text
end

post '/write_text' do
  text = params['text']
  render 'html.erb', :result, {}, text: text
end
