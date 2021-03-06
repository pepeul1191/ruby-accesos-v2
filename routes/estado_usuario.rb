class MyApp < Sinatra::Base
  before '/estado_usuario*' do
    check_csrf
  end

  get '/estado_usuario/listar' do
    rpta = []
    status = 200
    begin
      rpta = EstadoUsuario.all().to_a
    rescue Exception => e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los estados de usuario',
          e.message
        ]}
    end
    status status
    rpta.to_json
  end
end
