require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/contrib'

set :port, 7101

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

helpers do
  def print(text)
    return '-' if text.nil? || text.empty?
    text
  end
end

secured = {
  field1: nil,
  field2: nil
}
unsecured = {
  field1: nil,
  field2: nil
}
token = String.new

def gen_cookie
  (rand * 1000000000).round.to_s
end

get '/' do
  render 'html.erb', :index, {}, data: { secured: secured,
                                         unsecured: unsecured,
                                         token: token }
end

get '/set_cookie' do
  token = gen_cookie
  cookies[:csrf_token] = token
  redirect to('/')
end

post '/write_form1' do
  if token.length > 0 && params['token'] == token
    secured = {
      field1: params['field1'],
      field2: params['field2']
    }
  end
  redirect to('/')
end

post '/write_form2' do
  unsecured = {
    field1: params['field1'],
    field2: params['field2']
  }
  redirect to('/')
end
