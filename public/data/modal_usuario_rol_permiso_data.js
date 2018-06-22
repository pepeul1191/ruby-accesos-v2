var dataUsuarioRolPermisoView = {
  el: "body",
  containerModal: "modal-container",
  urlTemplate: STATICS_URL + "templates/usuario_rol_permiso.html",
  handlebarsTemplateId: "usuario-rol-permiso-template",
  targetMensaje: "mensajeRptaRolPermiso",
  context: {
    titulo_modal: "Roles y Permisos del Usuario",
  },
  closeFunction: function(){
    location.replace(BASE_URL + "accesos/#/usuario");
  },
};