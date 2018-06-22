class MyApp < Sinatra::Base
  before '/usuario*' do
    check_csrf
  end

  get '/usuario/listar' do
    rpta = []
    error = false
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

  post '/usuario/contrasenia_repetida' do
    rpta = 0
    error = false
    status = 200
    begin
      data = JSON.parse(params[:data])
      usuario_id = data['id']
      contrasenia = data['contrasenia']
      rpta = Usuario.where(:contrasenia => contrasenia, :id => usuario_id).count
      rpta = rpta.to_s
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar la contraseña del usuario',
          execption.message
        ]}.to_json
    end
    status status
    rpta
  end

  post '/usuario/guardar_usuario_correo' do
    data = JSON.parse(params[:usuario])
    rpta = []
    status = 200
    DB.transaction do
      begin
        id = data['id']
    	  usuario = data['usuario']
     	  correo = data['correo']
    		DB.transaction do
    			begin
    				e = Usuario.where(:id => id).first
    				e.usuario = usuario
    				e.correo = correo
    				e.save
    			rescue Exception => e
    				error = true
    				execption = e
    				Sequel::Rollback
    			end
    	  end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los datos generales del usuario',
          ]}
      rescue Exception => e
        Sequel::Rollback
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en guardar los datos generales del usuario',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end

  post '/usuario/guardar_contrasenia' do
    data = JSON.parse(params[:contrasenia])
    rpta = []
    status = 200
    DB.transaction do
      begin
        id = data['id']
        contrasenia = data['contrasenia']
        DB.transaction do
          begin
            e = Usuario.where(:id => id).first
            e.contrasenia = contrasenia
            e.save
          rescue Exception => e
            error = true
            execption = e
            Sequel::Rollback
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha el cambio de contraseña del usuario',
          ]}
      rescue Exception => e
        Sequel::Rollback
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en actualizar la contraseña del usaurio',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
