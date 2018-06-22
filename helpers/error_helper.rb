class MyApp < Sinatra::Base
  helpers do
    def error_css
      rpta = nil
      if CONSTANTS[:ambiente] == 'desarrollo'
        rpta = [
          'bower_components/bootstrap/dist/css/bootstrap.min',
          'bower_components/font-awesome/css/font-awesome.min',
          'bower_components/swp-backbone/assets/css/constants',
          'assets/css/constants',
          'assets/css/error',
        ]
      else
        rpta = [
          'dist/error.min',
        ]
      end
      rpta
    end

    def error_js
      rpta = nil
      if CONSTANTS[:ambiente] == 'desarrollo'
        rpta = [
        ]
      else
        rpta = [
        ]
      end
      rpta
    end
  end
end
