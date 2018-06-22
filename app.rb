require 'sinatra/base'
require 'json'
require_relative 'config/constants'
require_relative 'config/routes'
require_relative 'config/models'
require_relative 'config/helpers.rb'
require_relative 'config/filters.rb'

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

  get '/error/access/:error' do
    numero_error = params[:error]
    case numero_error.to_i
    when 404
      error = {
        :numero => 404,
        :mensaje => 'Archivo no encontrado',
        :descripcion => 'La página que busca no se encuentra en el servidor',
        :icono => 'fa fa-exclamation-triangle'
      }
    when 501
      error = {
        :numero => 501,
        :mensaje => 'Página en Contrucción',
        :descripcion => 'Lamentamos el incoveniente, estamos trabajando en ello.',
        :icono => 'fa fa-code-fork'
      }
    when 505
      error = {
        :numero => 505, :mensaje => 'Acceso restringido',
        :descripcion => 'Necesita estar logueado.',
        :icono => 'fa fa-ban'
      }
    when 8080
      error = {
        :numero => 8080, :mensaje => 'Tiempo de la sesion agotado',
        :descripcion => 'Vuelva a ingresar al sistema.',
        :icono => 'fa fa-clock-o'
      }
    else
      error = {
        :numero => 404, :mensaje => 'Archivo no encontrado',
        :descripcion => 'La página que busca no se encuentra en el servidor',
        :icono => 'fa fa-exclamation-triangle'
      }
    end
    locals = {
      :constants => CONSTANTS,
      :csss => error_css(),
      :jss => error_js(),
      :error => error,
      :title => 'Error'
    }
    status 404
    erb :'error/access', :layout => :'layouts/blank', :locals => locals
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
