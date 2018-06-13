class MyApp < Sinatra::Base
  get '/departamento/listar' do
    rpta = []
    error = false
    execption = nil
    status = 200
    begin
      rpta = Departamento.all.to_a
    rescue Exception => e
      error = true
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los departamentos',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/departamento/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Departamento.new(
              :nombre => nuevo['nombre']
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
            e = Departamento.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Departamento.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {
        :tipo_mensaje => 'success',
        :mensaje => [
          'Se ha registrado los cambios en los departamentos',
          array_nuevos
        ]}.to_json
    else
      status 500
      return {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en guardar la tabla de departamentos',
          execption.message
        ]}.to_json
    end
  end
end
