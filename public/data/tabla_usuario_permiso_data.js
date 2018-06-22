var dataTablaUsuarioPermiso = {
  el: "#formTableUsuarioPermiso",
  idTable: "tablaUsuarioPermiso",
  targetMensaje: "mensajeRptaUsuarioPermiso",
  mensajes: {
    errorListarAjax: "Error en listar los datos del servidor",
    errorGuardarAjax: "Error en guardar los datos en el servidor",
    success: "Se cargado guardo los cambios en los autores",
  },
  urlGuardar: BASE_URL + "usuario/permiso/guardar",
  urlListar: BASE_URL + "usuario/permiso/",
  fila: {
    id: { // llave de REST
      tipo: "td_id",
      estilos: "color: blue; display:none",
      edicion: false,
    },
    nombre: { // llave de REST
      tipo: "label",
      estilos: "width: 150px;",
      edicion: true,
    },
    llave: { // llave de REST
      tipo: "label",
      estilos: "width: 150px;",
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
  tableKeys: ['id', 'nombre', "llave",'existe'],
  filaBotones: [
  ],
  collection: new PermisosCollection(),
  model: "Permiso",
};
