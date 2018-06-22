function limpiarURL(url_original, parametro){
  return url_original + parametro;
}

var accesosRouter = Backbone.Router.extend({
  sistemaView: null,
  sistemaMenuView: null,
  sistemaPermisoView: null,
  sistemaRolView: null,
  usuarioView: null,
  usuarioLogView: null,
  usuarioDetalleView: null,
  usuarioSistemaView: null,
  usuarioRolPermisoView: null,
  initialize: function() {
  },
  routes: {
    "": "index",
    "sistema" : "sistemaIndex",
    "sistema/menu/:sistema_id" : "sistemaMenu",
    "sistema/permiso/:sistema_id" : "sistemaPermiso",
    "sistema/rol/:sistema_id" : "sistemaRol",
    "usuario/logs/:usuario_id" : "usuarioLog",
    "usuario/editar/:usuario_id" : "usuarioDetalle", 
    "usuario/sistema/:usuario_id" : "usuarioSistema", 
    "usuario/roles_permisos/:usuario_id" : "usuarioRolPermiso", 
    "usuario" : "usuarioIndex",
    "*actions" : "default",
  },
  index: function(){
    window.location.href = BASE_URL + "accesos/#/sistema";
  },
  default: function() {
    //window.location.href = BASE_URL + "error/access/404";
  },
  //sistema
  sistemaIndex: function(){
    if(this.sistemaView == null){
      this.sistemaView = new SistemaView();
    }
    this.sistemaView.render();
    this.sistemaView.tablaSistema.listar();
  },
  sistemaMenu: function(sistema_id){
    if(this.sistemaMenuView == null){
      this.sistemaMenuView = new SistemaMenuView(dataSistemaMenuView);
    }
    this.sistemaMenuView.render();
    this.sistemaMenuView.tablaModulo.urlListar = 
      limpiarURL(BASE_URL + "modulo/listar/" , sistema_id);
    this.sistemaMenuView.sistemaId = sistema_id;
    this.sistemaMenuView.tablaModulo.listar(sistema_id);
  },
  sistemaPermiso: function(sistema_id){
    if(this.sistemaPermisoView == null){
      this.sistemaPermisoView = new SistemaPermisoView(dataSistemaPermisoView);
    }
    this.sistemaPermisoView.render();
    this.sistemaPermisoView.tablaPermiso.urlListar = 
      limpiarURL(BASE_URL + "permiso/listar/" , sistema_id);
    this.sistemaPermisoView.sistemaId = sistema_id;
    this.sistemaPermisoView.tablaPermiso.listar(sistema_id);
  },
  sistemaRol: function(sistema_id){
    if(this.sistemaRolView == null){
      this.sistemaRolView = new SistemaRolView(dataSistemaRolView);
    }
    this.sistemaRolView.render();
    this.sistemaRolView.tablaRol.urlListar = 
      limpiarURL(BASE_URL + "rol/listar/" , sistema_id);
    this.sistemaRolView.sistemaId = sistema_id;
    this.sistemaRolView.tablaRol.listar(sistema_id);
    this.sistemaRolView.tablaRolPermiso.sistemaId = sistema_id;
  },
  //usuario
  usuarioIndex: function(){
    if(this.usuarioView == null){
      this.usuarioView = new UsuarioView();
    }
    this.usuarioView.render();
    this.usuarioView.tablaUsuario.listar();
  },
  usuarioLog: function(usuario_id){
    if(this.usuarioLogView == null){
      this.usuarioLogView = new UsuarioLogView(dataUsuarioLogView);
    }
    this.usuarioLogView.render();
    //this.sistemaRolView.usuarioId = usuario_id;
    //this.usuarioLogView.tablaUsuario.listar();
  },
  usuarioDetalle: function(usuario_id){
    if(this.usuarioDetalleView == null){
      this.usuarioDetalleView = new UsuarioDetalleView(dataUsuarioDetalleView);
    }
    this.usuarioDetalleView.set("usuario_id", usuario_id);
    this.usuarioDetalleView.llenarSelect();
    this.usuarioDetalleView.obtenerUsuarioCorreo();
    this.usuarioDetalleView.context.usuario = this.usuarioDetalleView.model;
    this.usuarioDetalleView.context.estados = this.usuarioDetalleView.estadoUsuariosSelect.toJSON();
    this.usuarioDetalleView.render();
  },
  usuarioSistema: function(usuario_id){
    if(this.usuarioSistemaView == null){
      this.usuarioSistemaView = new UsuarioSistemaView(dataUsuarioSistemaView);
    }
    this.usuarioSistemaView.render();
    this.usuarioSistemaView.tablaSistema.urlListar = 
      limpiarURL(BASE_URL + "usuario/sistema/" , usuario_id);
    this.usuarioSistemaView.usuarioId = usuario_id;
    this.usuarioSistemaView.tablaSistema.listar(usuario_id);
    this.usuarioSistemaView.tablaSistema.usuarioId = usuario_id;
  },
  usuarioRolPermiso: function(usuario_id){
    if(this.usuarioRolPermisoView == null){
      this.usuarioRolPermisoView = new UsuarioRolPermisoView(dataUsuarioRolPermisoView);
    }
    this.usuarioRolPermisoView.set("usuario_id", usuario_id);
    this.usuarioRolPermisoView.context.sistemas = this.usuarioRolPermisoView.cbmSistemas();
    this.usuarioRolPermisoView.context.usuario_id = usuario_id;
    this.usuarioRolPermisoView.render();
  },
});

$(document).ready(function(){
  router = new accesosRouter();
  Backbone.history.start();
})
