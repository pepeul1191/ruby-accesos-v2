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
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los usuarios',
          e.message
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
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en  obtener el usuario y correo',
          e.message
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
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar el nombre de usuario repetido',
          e.message
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
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar el correo del usuario',
          e.message
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
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en validar la contraseña del usuario',
          e.message
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
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en guardar los datos generales del usuario',
            e.message
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
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en actualizar la contraseña del usaurio',
            e.message
          ]}
      end
    end
    status status
    rpta.to_json
  end

  get '/usuario/sistema/:usuario_id' do
    rpta = []
    status = 200
    DB.transaction do
      begin
        usuario_id = params[:usuario_id]
        rpta = DB.fetch('
          SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
          (
            SELECT id, nombre, 0 AS existe FROM sistemas
          ) T
          LEFT JOIN
          (
            SELECT S.id, S.nombre, 1 AS existe FROM sistemas S
            INNER JOIN usuarios_sistemas US ON US.sistema_id = S.id
            WHERE US.usuario_id = ?
          ) P
          ON T.id = P.id', usuario_id).to_a
      rescue Exception => e
        Sequel::Rollback
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en listar los sistemas del usuario',
            e.message
          ]}
      end
    end
    status status
    rpta.to_json
  end

  post '/usuario/sistema/guardar' do
    rpta = []
    status = 200
    data = JSON.parse(params[:data])
    editados = data['editados']
    usuario_id = data['extra']['usuario_id']
    DB.transaction do
      begin
        if editados.length != 0
          editados.each do |editado|
            existe = editado['existe']
            sistema_id = editado['id']
            e = UsuarioSistema.where(
              :sistema_id => sistema_id,
              :usuario_id => usuario_id
            ).first
            if existe == 0 #borrar si existe
              if e != nil
                e.delete
              end
            elsif existe == 1 #crear si no existe
              if e == nil
                n = UsuarioSistema.new(
                  :sistema_id => sistema_id,
                  :usuario_id => usuario_id
                )
                n.save
              end
            end
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado la asociación de permisos al rol',
          ]}
      rescue Exception => e
        Sequel::Rollback
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en listar los sistemas del usuario',
            e.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
