class MyApp < Sinatra::Base
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
        {
          :url => 'maestros/',
          :nombre => 'Maestros',
        },
        {
          :url => 'agricultores/',
          :nombre => 'Agricultores',
        },
        {
          :url => 'estaciones/',
          :nombre => 'Estaciones',
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
  			:titulo_pagina => 'Gestión de Agricultores',
  			:modulo => 'Accesos',
  		}.to_json,
    }
		erb :'home/index', :layout => :'layouts/app', :locals => locals
  end
end
