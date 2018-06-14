require_relative './database'

class Sistema < Sequel::Model(DB[:sistemas])

end

class Modulo < Sequel::Model(DB[:modulos])

end

class Subtitulo < Sequel::Model(DB[:subtitulos])

end
