var dataUsuarioDetalleView = {
  el: "body",
  containerModal: "modal-container",
  urlTemplate: STATICS_URL + "templates/usuario_detalle.html",
  handlebarsTemplateId: "usuario-detalle-template",
  targetMensaje: "mensajeRptaDetalle",
  context: {
    titulo_modal: "Edite los datos del usuario",
  },
  closeFunction: function(){
    location.replace(BASE_URL + "accesos/#/usuario");
  },
};