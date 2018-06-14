require_relative './database'

class Sistema < Sequel::Model(DB[:sistemas])

end

class Modulo < Sequel::Model(DB[:modulos])

end

class Subtitulo < Sequel::Model(DB[:subtitulos])

end

class Item < Sequel::Model(DB[:items])

end

class Permiso < Sequel::Model(DB[:permisos])

end
