class MyApp < Sinatra::Base
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
