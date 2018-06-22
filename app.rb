require 'sinatra/base'
require 'json'
require_relative 'config/constants'
require_relative 'config/routes'
require_relative 'config/models'
require_relative 'config/helpers.rb'

class MyApp < Sinatra::Base
  enable :method_override
  enable :sessions
  set :session_secret, 'super secret'
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :layout, 'views/layouts'

  configure do
    set :app_file, __FILE__
  end

  configure :development do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :qa do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :production do
    set :raise_errors, false #false will show nicer error page
    set :show_exceptions, false #true will ignore raise_errors and display backtrace in browser
  end

  before do
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Content-type'] = 'text/html; charset=UTF-8'
    headers['server'] = 'Ruby, Ubuntu'
  end

  get '/test/conexion' do
    'Ok'
  end

  get '/' do
    redirect '/accesos/'
  end

  not_found do
    rpta = ''
    status = 404
    case request.env['REQUEST_METHOD']
    when 'GET'
      error = {
        :numero => 404,
        :mensaje => 'Archivo no encontrado',
        :descripcion => 'La página que busca no se encuentra en el servidor',
        :icono => 'fa fa-exclamation-triangle'
      }
      locals = {
        :constants => CONSTANTS,
        :csss => error_css(),
        :jss => error_js(),
        :error => error,
        :title => 'Error'
      }
      status 404
      return erb :'error/access', :layout => :'layouts/blank', :locals => locals
    else
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Recurso no encontrado',
          'El recurso que busca no se encuentra en el servidor'
        ]}
    end
    rpta.to_json
  end
end
