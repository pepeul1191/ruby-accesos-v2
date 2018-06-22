var EstadoUsuariosCollection = Backbone.Collection.extend({
  model: EstadoUsuario,
  obtenerModels: function(){
    return this.models;
  },
});
