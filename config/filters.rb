class MyApp < Sinatra::Base
  helpers do
    def check_csrf
      csrf_key = 'HTTP_' + CONSTANTS[:CSRF][:key].upcase
      csrf_val = CONSTANTS[:CSRF][:secret]
      if request.env[csrf_key] != csrf_val then
        rpta = {
          :tipo_mensaje => 'error',
          :mensaje => [
            'No se puede acceder al recurso',
            'CSRF Token key error'
          ]}
        halt 500, rpta.to_json
      end
    end

    def check_session_true

    end

    def check_session_false

    end
  end
end
