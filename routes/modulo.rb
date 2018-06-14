class MyApp < Sinatra::Base
  get '/modulo/listar/:sistema_id' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      sistema_id = params['sistema_id']
      rpta = Modulo.select(:id, :url, :nombre).where(:sistema_id => sistema_id).all().to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los módulos del sistema',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/modulo/guardar' do
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
            n = Modulo.new(
              :nombre => nuevo['nombre'],
              :icono => nuevo['icono'],
              :url => nuevo['url'],
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
            e = Modulo.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.icono = editado['icono']
            e.url = editado['url']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Modulo.where(:id => eliminado).delete
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los sistemas',
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
            'Se ha producido un error en guardar la tabla de sistemas',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
