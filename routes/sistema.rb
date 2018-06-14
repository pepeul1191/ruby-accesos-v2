class MyApp < Sinatra::Base
  get '/sistema/listar' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      rpta = Sistema.all.to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los sistemas',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/sistema/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    status = 200
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Sistema.new(
              :nombre => nuevo['nombre']
            )
            n.save
            t = {
              :temporal => nuevo['id'],
              :nuevo_id => nuevo['id'],
              :version => nuevo['version'],
              :repositorio => nuevo['repositorio']
            }
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Sistema.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.version = editado['version']
            e.repositorio = editado['repositorio']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Sistema.where(:id => eliminado).delete
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
