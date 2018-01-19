require 'sinatra'; # gem install sinatra
require 'savon'; # gem install savon

def connect
    client = Savon.client(:wsdl => "http://81.23.108.42/ex/ws.wsdl")
    return client
end

def get_token(client)
    token = client.call :get_token
    return token.body[:get_token_response][:return]
end

def rest_list(client, token)
	msg = Hash.new
	msg["token"] = token;

	res = client.call(:get_restaurant_list, message: msg)
	return res.body[:get_restaurant_list_response][:return][:item]

end

def action_list(client, token, id_rest)
	msg = Hash.new
	msg["token"] = token;
	msg["restaurant_id"] = id_rest;

	res = client.call(:get_restaurant_actions, message: msg)
    return res.body[:get_restaurant_actions_response][:return][:item]
end

def dir_name(client, token, id_rest)
	msg = Hash.new
	msg["token"] = token;
	msg["restaurant_id"] = id_rest;

	res = client.call(:get_dir_name, message: msg)
	return res.body[:get_dir_name_response][:return]
end

get '/' do
	cli = connect
	token = get_token(cli)
	@rest = rest_list(cli, token)
    erb :index
end

get '/:id' do
	@id = params[:id]
	cli = connect
	token = get_token(cli)
	@rest = rest_list(cli, token)
	@actions = action_list(cli, token, @id)
	@dir_name = dir_name(cli, token, @id)
    erb :index
end
