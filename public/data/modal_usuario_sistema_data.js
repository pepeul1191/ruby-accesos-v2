var dataUsuarioSistemaView = {
  el: "body",
  containerModal: "modal-container",
  urlTemplate: STATICS_URL + "templates/usuario_sistema.html",
  handlebarsTemplateId: "usuario-sistema-template",
  targetMensaje: "mensajeRptaSistema",
  context: {
    titulo_modal: "Sistemas Asociados al Usuario",
  },
  closeFunction: function(){
    location.replace(BASE_URL + "accesos/#/usuario");
  },
};