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

class Rol < Sequel::Model(DB[:roles])

end

class RolPermiso < Sequel::Model(DB[:roles_permisos])

end

class Usuario < Sequel::Model(DB[:usuarios])

end

class UsuarioSistema < Sequel::Model(DB[:usuarios_sistemas])

end

class EstadoUsuario < Sequel::Model(DB[:estado_usuarios])

end

class UsuarioPermiso < Sequel::Model(DB[:usuarios_permisos])

end

class UsuarioRol < Sequel::Model(DB[:usuarios_roles])

end

class VWUsuarioEstadoEstado < Sequel::Model(DB[:vw_usuario_correo_estado])

end

class Acceso < Sequel::Model(DB[:accesos])

end
