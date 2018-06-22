class MyApp < Sinatra::Base
  helpers do
    def login_css
      rpta = nil
      if CONSTANTS[:ambiente] == 'desarrollo'
        rpta = [
          'bower_components/bootstrap/dist/css/bootstrap.min',
          'bower_components/font-awesome/css/font-awesome.min',
          'bower_components/swp-backbone/assets/css/constants',
          'bower_components/swp-backbone/assets/css/login',
          'assets/css/constants',
          'assets/css/login',
        ]
      else
        rpta = [
          'dist/login.min',
        ]
      end
      rpta
    end

    def login_js
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
