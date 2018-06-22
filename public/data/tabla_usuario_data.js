var dataTablaUsuario = {
  el: "#formTableUsuario",
  idTable: "tablaUsuario",
  targetMensaje: "mensajeRptaUsuario",
  mensajes: {
    errorListarAjax: "Error en listar los datos del servidor",
    errorGuardarAjax: "Error en guardar los datos en el servidor",
    success: "Se cargado guardo los cambios en los usuarios",
  },
  urlGuardar: BASE_URL + "usuario/guardar",
  urlListar: BASE_URL + "usuario/listar",
  fila: {
    id: { // llave de REST
      tipo: "td_id",
      estilos: "color: blue; display:none",
      edicion: false,
    },
    usuario: { // llave de REST
      tipo: "label",
      estilos: "width: 200px;",
      edicion: true,
    },
    correo: { // llave de REST
      tipo: "label",
      estilos: "width: 200px;",
      edicion: true,
    },
    filaBotones: {
      estilos: "width: 80px; padding-left: 4px;"
    },
  },
  tableKeys: ["id", "usuario", "correo"],
  filaBotones: [
    {
      tipo: "href",
      claseOperacion: "ver-accesos",
      clase: "fa-thumb-tack",
      estilos: "padding-left: 10px;",
      url: BASE_URL + 'accesos/#/usuario/logs/'/*+ usuario_id*/,
    },
    {
      tipo: "href",
      claseOperacion: "editar-usuario",
      clase: "fa-pencil",
      estilos: "padding-left: 10px;",
      url: BASE_URL + 'accesos/#/usuario/editar/'/*+ usuario_id*/,
    },
    {
      tipo: "href",
      claseOperacion: "asociar-sistemas",
      clase: "fa-laptop",
      estilos: "padding-left: 10px;",
      url: BASE_URL + 'accesos/#/usuario/sistema/'/*+ usuario_id*/,
    },
    {
      tipo: "href",
      claseOperacion: "asociar-roles-permisos",
      clase: "fa-list",
      estilos: "padding-left: 10px;",
      url: BASE_URL + 'accesos/#/usuario/roles_permisos/'/*+ usuario_id*/,
    },
  ],
  collection: new UsuariosCollection(),
  model: "Usuario",
};
