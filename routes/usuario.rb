class MyApp < Sinatra::Base
  before '/usuario*' do
    check_csrf
  end

  get '/usuario/listar' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      rpta = Usuario.select(:id, :usuario, :correo).all().to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los usuarios',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end
end
