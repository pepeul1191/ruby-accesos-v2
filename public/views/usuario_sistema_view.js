var UsuarioSistemaView = ModalView.extend({
  usuarioId: null,
  initialize: function(options){
    this.targetMensaje = options["targetMensaje"];
    // herencia de atributos, móetodos y eventos
    ModalView.prototype.initialize.apply(this, [options])
    this.inheritEvents(ModalView);
    // delegación de eventos
    this.delegateEvents();
    this.tablaSistema = new TableView(dataTablaUsuarioSistema);
  },
  events: {
    // se está usando asignacion dinamica de eventos en el constructor
    // tabla sistemas de usuario
    "change #tablaUsuarioSistema > tbody > tr > td > .input-check": "clickCheckBoxSistemaUsuario",
    "click #tablaUsuarioSistema > tfoot > tr > td > button.guardar-tabla": "guardarTablaSistemaUsuario",
  },
  //eventos tabla de sistemas de usuario
  clickCheckBoxSistemaUsuario: function(event){
    this.tablaSistema.clickCheckBox(event);
  },
  guardarTablaSistemaUsuario: function(event){
    this.tablaSistema.extraData = {
      usuario_id: this.usuarioId,
    };
    this.tablaSistema.guardarTabla(event);
  },
});