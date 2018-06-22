var dataTablaUsuarioRol = {
  el: "#formTableUsuarioRol",
  idTable: "tablaUsuarioRol",
  targetMensaje: "mensajeRptaUsuarioRol",
  mensajes: {
    errorListarAjax: "Error en listar los datos del servidor",
    errorGuardarAjax: "Error en guardar los datos en el servidor",
    success: "Se cargado guardo los cambios en los autores",
  },
  urlGuardar: BASE_URL + "usuario/rol/guardar",
  urlListar: BASE_URL + "usuario/rol/",
  fila: {
    id: { // llave de REST
      tipo: "td_id",
      estilos: "color: blue; display:none",
      edicion: false,
    },
    nombre: { // llave de REST
      tipo: "label",
      estilos: "width: 200px;",
      edicion: true,
    },
    existe: {
      tipo: "check",
      estilos: "width: 30px; padding-left:20px;",
      edicion: true,
      key: "existe",
    },
    filaBotones: {
      estilos: "display: none;"
    },
  },
  tableKeys: ['id', 'nombre', 'existe'],
  filaBotones: [
  ],
  collection: new RolesCollection(),
  model: "Rol",
};
