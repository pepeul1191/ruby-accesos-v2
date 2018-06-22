class MyApp < Sinatra::Base
  before '/item*' do
    check_csrf
  end

  get '/item/listar/:subtitulo_id' do
    rpta = []
    status = 200
    begin
      subtitulo_id = params['subtitulo_id']
      rpta = Item.select(:id, :nombre, :url).where(:subtitulo_id => subtitulo_id).all().to_a
    rescue Exception => e
      execption = e
      status = 500
      rpta = {
        :tipo_mensaje => 'error',
        :mensaje => [
          'Se ha producido un error en listar los items del subtitulo',
          execption.message
        ]}
    end
    status status
    rpta.to_json
  end

  post '/item/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    subtitulo_id = data['extra']['subtitulo_id']
    rpta = []
    array_nuevos = []
    status = 200
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Item.new(
              :nombre => nuevo['nombre'],
              :url => nuevo['url'],
              :subtitulo_id => subtitulo_id
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
            e = Item.where(
              :id => editado['id']
            ).first
            e.nombre = editado['nombre']
            e.url = editado['url']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Item.where(:id => eliminado).delete
          end
        end
        rpta = {
          :tipo_mensaje => 'success',
          :mensaje => [
            'Se ha registrado los cambios en los items del subtítulo',
            array_nuevos
          ]}
      rescue Exception => e
        Sequel::Rollback
        execption = e
        status = 500
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'Se ha producido un error en guardar la tabla de items',
            execption.message
          ]}
      end
    end
    status status
    rpta.to_json
  end
end
