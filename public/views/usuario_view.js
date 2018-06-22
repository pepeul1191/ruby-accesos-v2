var UsuarioView = Backbone.View.extend({
	el: '#workspace',
	initialize: function(){
		//this.render();
		//console.log("initialize");
		this.events = this.events || {};
    this.tablaUsuario =  new TableView(dataTablaUsuario);
	},
	events: {
		// se está usando asignacion dinamica de eventos en el constructor
    //eventos tabla de departamentos
		"click #tablaUsuario > tfoot > tr > td > button.guardar-tabla": "guardarTablaUsuario",
		"keyup #tablaUsuario > tbody > tr > td > input.text": "inputTextEscribirUsuario",
		"click #tablaUsuario > tbody > tr > td > i.quitar-fila": "quitarFilaUsuario",
	},
	render: function() {
		this.$el.html(this.getTemplate());
	},
	getTemplate: function() {
		var data = { };
		var template_compiled = null;
		$.ajax({
		   url: STATICS_URL + 'templates/usuario.html',
		   type: "GET",
		   async: false,
		   success: function(source) {
		   	var template = Handlebars.compile(source);
		   	template_compiled = template(data);
		   }
		});
		return template_compiled;
	},
	mostrarTabla: function(){
		this.tabla.listar();
	},
  //evnetos tabla de departamentos
  inputTextEscribirUsuario: function(event){
    this.tablaUsuario.inputTextEscribir(event);
  },
  quitarFilaUsuario: function(event){
    this.tablaUsuario.quitarFila(event);
  },
  guardarTablaUsuario: function(event){
    this.tablaUsuario.guardarTabla(event);
  },
});
