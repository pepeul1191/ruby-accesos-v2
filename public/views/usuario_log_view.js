var UsuarioLogView = ModalView.extend({
  usuarioId: null,
  initialize: function(options){
    this.targetMensaje = options["targetMensaje"];
    // herencia de atributos, móetodos y eventos
    ModalView.prototype.initialize.apply(this, [options])
    this.inheritEvents(ModalView);
    // delegación de eventos
    this.delegateEvents();
    //this.tablaLog = new TableView(dataTablaLog);
  },
  events: {
    // se está usando asignacion dinamica de eventos en el constructor
    // tabla modulos
  },
});