class MyApp < Sinatra::Base
  before '/login' do
    check_session_true
  end

  get '/login' do
    locals = {
      :constants => CONSTANTS,
      :csss => login_css(),
      :jss => login_js(),
      :title => 'Bienvenido',
      :mensaje => ''
    }
		erb :'login/index', :layout => :'layouts/blank', :locals => locals
  end

  get '/login/cerrar' do
    session.clear
    redirect '/login'
  end

  get '/login/ver' do
    rpta = ''
    status = 200
    begin
    rpta = rpta + 'estado : ' + session[:activo].to_s + '<br>'
    rpta = rpta + 'momento : ' + session[:momento].to_s + '<br>'
    rpta = rpta + 'usuario : ' + session[:usuario] + '<br>'
    rescue TypeError => e
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en mostrar los datos de la sesión',
          execption.message
        ]}.to_json
    end
    status status
    rpta
  end

  post '/login/acceder' do
    mensaje = ''
    continuar = true
    csrf_key = CONSTANTS[:CSRF][:key]
    csrf_val = CONSTANTS[:CSRF][:secret]
    csrf_req = params[csrf_key]
    if csrf_req == '' then
      mensaje = 'Token CSRF no existe en POST request'
      continuar = false
    else
      # validar csrf token
      if csrf_req != csrf_val then
        mensaje = 'Token CSRF no coincide en POST request'
        continuar = false
      end
      # validar usuario y contraseña si csrf token es correcto
      if continuar == true then
        usuario = params['usuario']
        contrasenia = params['contrasenia']
        if usuario != CONSTANTS[:login][:usuario] or contrasenia != CONSTANTS[:login][:contrasenia] then
          mensaje = 'Usuario y/o contraenia no coinciden'
          continuar = false
        end
      end
    end
    if continuar == true then
      session[:activo] = true
      session[:momento] = Time.now
      session[:usuario] = usuario
      redirect '/accesos/'
    else
      locals = {
        :constants => CONSTANTS,
        :csss => login_css(),
        :jss => login_js(),
        :title => 'Bienvenido',
        :mensaje => mensaje
      }
  		erb :'login/index', :layout => :'layouts/blank', :locals => locals
    end
  end

  get '/accesos' do
    redirect '/accesos/'
  end

  before '/accesos/' do
    check_session_false
  end

  get '/accesos/' do
    locals = {
      :constants => CONSTANTS,
      :csss => home_css(),
      :jss => home_js(),
      :modulos => [
        {
          :url => 'accesos/',
          :nombre => 'Accesos',
        },
      ].to_json,
      :items => [
        {
          :subtitulo => 'Opciones',
          :items => [
            {
              :item => 'Gestión de Sistemas',
              :url => 'accesos/#/sistema',
            },
            {
              :item => 'Gestión de Usuarios',
              :url => 'accesos/#/usuario',
            },
          ],
        },
      ].to_json,
      :data => {
  			:mensaje => false,
  			:titulo_pagina => 'Gestión de Accesos',
  			:modulo => 'Accesos',
  		}.to_json,
    }
		erb :'home/index', :layout => :'layouts/app', :locals => locals
  end
end
