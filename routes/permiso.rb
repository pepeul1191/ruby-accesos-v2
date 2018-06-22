class MyApp < Sinatra::Base
  before '/permiso*' do
    check_csrf
  end

  get '/permiso/listar/:sistema_id' do
    rpta = []
    execption = nil
    status = 200
    begin
      sistema_id = params['sistema_id']
      rpta = Permiso.select(:id, :nombre, :llave).where(:sistema_id => sistema_id).all().to_a
    rescue Exception => e
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los permisos del sistema',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/permiso/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    sistema_id = data['extra']['sistema_id']
    rpta = []
    array_nuevos = []
    execption = nil
    status = 200
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Permiso.new(
              :nombre => nuevo['nombre'],
              :llave => nuevo['llave'],
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
            e = Permiso.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.llave = editado['llave']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Permiso.where(:id => eliminado).delete
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los permisos del sistema',
            array_nuevos
          ]}
      rescue Exception => e
        Sequel::Rollback
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en guardar la tabla de permisos',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
