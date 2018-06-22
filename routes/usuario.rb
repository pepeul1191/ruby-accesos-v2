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


  get '/usuario/obtener_usuario_correo/:usuario_id' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      usuario_id = params['usuario_id']
      rpta = VWUsuarioEstadoEstado.where(:id => usuario_id).first()
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en  obtener el usuario y correo',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/usuario/nombre_repetido' do
    rpta = 0
    error = false
    execption = nil
    status = 200
    begin
      data = JSON.parse(params[:data])
  	  usuario_id = data['id']
   	  usuario = data['usuario']
  		rpta = 0
  		if usuario_id == 'E'
  			#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
  			rpta = Usuario.where(:usuario => usuario).count
  		else
  			#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND id = ?
  			rpta = Usuario.where(:usuario => usuario, :id => usuario_id).count
  			if rpta == 1
  				rpta = 0
  			else
  				#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
  				rpta = Usuario.where(:usuario => usuario).count
  			end
  		end
      rpta = rpta.to_s
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar el nombre de usuario repetido',
          execption.message
        ]}.to_json
    end
    status status
    rpta
  end

  post '/usuario/correo_repetido' do
    rpta = 0
    error = false
    execption = nil
    status = 200
    begin
      data = JSON.parse(params[:data])
      usuario_id = data['id']
      correo = data['correo']
      rpta = 0
      if usuario_id == 'E'
        #SELECT COUNT(*) AS cantidad FROM usuarios WHERE correo = ?
        rpta = Usuario.where(:correo => correo).count
      else
        #SELECT COUNT(*) AS cantidad FROM usuarios WHERE correo = ? AND id = ?
        rpta = Usuario.where(:correo => correo, :id => usuario_id).count
        if rpta == 1
          rpta = 0
        else
          #SELECT COUNT(*) AS cantidad FROM usuarios WHERE correo = ?
          rpta = Usuario.where(:correo => correo).count
        end
      end
      rpta = rpta.to_s
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar el correo del usuario',
          execption.message
        ]}.to_json
    end
    status status
    rpta
  end
end
