var UsuarioRolPermisoView = ModalView.extend({
  usuarioId: null,
  initialize: function(options){
    this.targetMensaje = options["targetMensaje"];
    // herencia de atributos, móetodos y eventos
    ModalView.prototype.initialize.apply(this, [options])
    this.inheritEvents(ModalView);
    // delegación de eventos
    this.delegateEvents();
    this.tablaPermiso = new TableView(dataTablaUsuarioPermiso);
    this.tablaRol = new TableView(dataTablaUsuarioRol);
  },
  events: {
    // se está usando asignacion dinamica de eventos en el constructor
    "change #cbmSistema": "seleccionarSistema",
     // tabla roles de usuario
     "change #tablaUsuarioRol > tbody > tr > td > .input-check": "clickCheckBoxRolUsuario",
     "click #tablaUsuarioRol > tfoot > tr > td > button.guardar-tabla": "guardarTablaRolUsuario",
     // tabla permisos de usuario
     "change #tablaUsuarioPermiso > tbody > tr > td > .input-check": "clickCheckBoxPermisoUsuario",
     "click #tablaUsuarioPermiso > tfoot > tr > td > button.guardar-tabla": "guardarTablaPermisoUsuario",
  },
  //llenarcombo
  cbmSistemas:function(){
    var usuario_id = this.get("usuario_id");
    var rpta = [];
    $.ajax({
      type: "GET",
      url: BASE_URL + "usuario/sistema/" + usuario_id,
      headers: {
        [CSRF_KEY]: CSRF,
      },
      data: "",
      async: false,
      success: function(data){
        var sistemas = JSON.parse(data);
        for(var i = 0; i < sistemas.length; i++){
          var t = {
            id: sistemas[i].id,
            nombre: sistemas[i].nombre,
          };
          rpta.push(t);
        }
      },
      error: function(data){
        console.error("Error en listar los sistemas del usuario", data);
      }
    });
    return rpta;
  },
  //seleccionar combo
  seleccionarSistema: function(event){
    var sistema_id = event.target.value;
    var usuario_id = this.get("usuario_id");
    //borrar body de tablas
    $("#tablaUsuarioPermiso > tbody").empty();
    $("#tablaUsuarioRol > tbody").empty();
    if(sistema_id != "E"){
      $("#fila-tablas").removeClass("oculto");
      //llenar tabla de roles
      this.tablaRol.urlListar = 
        limpiarURL(BASE_URL + "usuario/rol/" , sistema_id + "/" + usuario_id);
      this.tablaRol.listar();
      this.tablaRol.usuarioId = usuario_id;
      this.tablaRol.sistemaId = sistema_id;
      //llenar tabla de permisos
      this.tablaPermiso.urlListar = 
        limpiarURL(BASE_URL + "usuario/permiso/" , sistema_id + "/" + usuario_id);
      this.tablaPermiso.listar();
      this.tablaPermiso.usuarioId = usuario_id;
      this.tablaPermiso.sistemaId = sistema_id;
    }else{
      $("#fila-tablas").addClass("oculto");
    }
  },
  clickCheckBoxRolUsuario: function(event){
    this.tablaRol.clickCheckBox(event);
  },
  guardarTablaRolUsuario: function(event){
    this.tablaRol.extraData = {
      sistema_id: this.tablaRol.sistemaId,
      usuario_id: this.tablaRol.usuarioId,
    };
    this.tablaRol.guardarTabla(event);
  },
  clickCheckBoxPermisoUsuario: function(event){
    this.tablaPermiso.clickCheckBox(event);
  },
  guardarTablaPermisoUsuario: function(event){
    this.tablaPermiso.extraData = {
      sistema_id: this.tablaPermiso.sistemaId,
      usuario_id: this.tablaPermiso.usuarioId,
    };
    this.tablaPermiso.guardarTabla(event);
  },
});