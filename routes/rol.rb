class MyApp < Sinatra::Base
  get '/rol/listar/:sistema_id' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      sistema_id = params['sistema_id']
      rpta = Rol.select(:id, :nombre).where(:sistema_id => sistema_id).all().to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los roles del sistema',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/rol/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    sistema_id = data['extra']['sistema_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    status = 200
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Rol.new(
              :nombre => nuevo['nombre'],
              :sistema_id => sistema_id
            )
            n.save
            t = {
              :temporal => nuevo['id'],
              :nuevo_id => n.id
            }
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Rol.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Rol.where(:id => eliminado).delete
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los roles del sistema',
            array_nuevos
          ]}
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en guardar la tabla de roles',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end

  get '/rol/permiso/listar/:sistema_id/:rol_id' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      sistema_id = params['sistema_id']
      rol_id = params['rol_id']
      rpta = DB.fetch('
    		SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe, T.llave AS llave FROM
    		(
    			SELECT id, nombre, llave, 0 AS existe FROM permisos WHERE sistema_id = ' + sistema_id + '
    		) T
    		LEFT JOIN
    		(
    			SELECT P.id, P.nombre,  P.llave, 1 AS existe  FROM permisos P
    			INNER JOIN roles_permisos RP ON P.id = RP.permiso_id
    			WHERE RP.rol_id =  ' + rol_id + '
    		) P
    		ON T.id = P.id').to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los permisos del rol',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/rol/permiso/guardar' do
    data = JSON.parse(params[:data])
    editados = data['editados']
    rol_id = data['extra']['rol_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    status = 200
    DB.transaction do
      begin
        if editados.length != 0
          editados.each do |editado|
            existe = editado['existe']
            permiso_id = editado['id']
            e = RolPermiso.where(
              :permiso_id => permiso_id,
              :rol_id => rol_id
            ).first
            if existe == 0 #borrar si existe
              if e != nil
                e.delete
              end
            elsif existe == 1 #crear si no existe
              if e == nil
                n = RolPermiso.new(
                  :permiso_id => permiso_id,
                  :rol_id => rol_id
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
            array_nuevos
          ]}
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en asociar los permisos al rol',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
