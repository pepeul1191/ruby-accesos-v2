class MyApp < Sinatra::Base
  before '/subtitulo*' do
    check_csrf
  end

  get '/subtitulo/listar/:modulo_id' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      modulo_id = params['modulo_id']
      rpta = Subtitulo.select(:id, :nombre).where(:modulo_id => modulo_id).all().to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los subtítulos del módulo',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/subtitulo/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    modulo_id = data['extra']['modulo_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    status = 200
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Subtitulo.new(
              :nombre => nuevo['nombre'],
              :modulo_id => modulo_id
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
            e = Subtitulo.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Subtitulo.where(:id => eliminado).delete
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los subtitulos del módulo',
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
            'Se ha producido un error en guardar la tabla de subtitulos',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
