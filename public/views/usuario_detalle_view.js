var UsuarioDetalleView = ModalView.extend({
  usuarioId: null,
  events: {
    // se está usando asignacion dinamica de eventos en el constructor
    "keyup #txtUsuario": "validarUsuarioRepetido", 
    "focusout #txtUsuario": "validarUsuarioLleno", 
    "keyup #txtCorreo": "validarCorreoRepetido", 
    "focusout #txtCorreo": "validarCorreoFormato", 
    "keyup #txtContraseniaAntgua": "validarContraseniaAntigua", 
    "focusout #txtContraseniaAntgua": "validarContraseniaLleno", 
    "focusout #txtContraseniaNueva": "validarContraseniaAntiguaDiferente", 
    "focusout #txtContraseniaNuevaRepetida": "validarContraseniaIgual", 
    "click #btnGuardarUsuarioCorreo": "guardarUsuarioCorreo",
    "click #btnCambiarContrasenia": "cambiarContrasenia"
  },
  initialize: function(options){
    this.targetMensaje = options["targetMensaje"];
    // herencia de atributos, móetodos y eventos
    ModalView.prototype.initialize.apply(this, [options])
    this.inheritEvents(ModalView);
    // delegación de eventos
    this.delegateEvents();
    this.estadoUsuariosSelect = new EstadoUsuariosCollection({
      targetMensaje: "defaultTargetMensajes",
    });
    this.model = new Usuario();
  },
  llenarSelect: function(){
    var responseData = [];
    var viewInstance = this;
    var models = []; // para evitar que el primero sea nulo
    $.ajax({
      type: "GET",
      url: BASE_URL + "estado_usuario/listar",
      data: {},
      headers: {
        [CSRF_KEY]: CSRF,
      },
      async: false,
      success: function(data){
        responseData = JSON.parse(data);
      },
      error: function(error){
        $("#" + viewInstance.targetMensaje).removeClass("color-success");
        $("#" + viewInstance.targetMensaje).removeClass("color-warning");
        $("#" + viewInstance.targetMensaje).addClass("color-danger");
        $("#" + viewInstance.targetMensaje).html("Error en listar los tipos de estaciones");
        $("html, body").animate({ scrollTop: $("#" + viewInstance.targetMensaje).offset().top }, 1000);
        console.log(error);
      }
    });
    if(responseData.length > 0){
      for(var i = 0; i < responseData.length; i++){
        var modelo = new EstadoUsuario(responseData[i]);
        this.estadoUsuariosSelect.models.push(modelo);
      }
    }
  },
  obtenerUsuarioCorreo: function(){
    var viewInstance = this;
    $.ajax({
      type: "GET",
      url: BASE_URL + "usuario/obtener_usuario_correo/" + viewInstance.get("usuario_id"),
      data: {},
      headers: {
        [CSRF_KEY]: CSRF,
      },
      async: false,
      success: function(data){
        viewInstance.model = JSON.parse(data);
      },
      error: function(error){
        $("#" + viewInstance.targetMensaje).removeClass("color-success");
        $("#" + viewInstance.targetMensaje).removeClass("color-warning");
        $("#" + viewInstance.targetMensaje).addClass("color-danger");
        $("#" + viewInstance.targetMensaje).html("Error en listar los tipos de estaciones");
        $("html, body").animate({ scrollTop: $("#" + viewInstance.targetMensaje).offset().top }, 1000);
        console.log(error);
      }
    });
  },
  validarUsuarioRepetido: function(event) {
		var usuario_valido_valor;
		var usuario_temp = new Object();
	  usuario_temp.id = this.model.id.toString();
	  usuario_temp.usuario  = $("#txtUsuario").val(),
     	$.ajax({
     		type: "POST",
     		url: BASE_URL + "usuario/nombre_repetido",
     		data: {
           data: JSON.stringify(usuario_temp)
        }, //"data=" + JSON.stringify(usuario_temp),
        headers: {
					[CSRF_KEY]: CSRF,
				},
     		async: false,
     		success: function(data){
     			if(data >= 1){
     				$("#txtUsuario").addClass("is-invalid");
     				$("#txtUsuario").parent().find("span").html("El nombre de usuario registrado ya se encuentra en uso");
     				usuario_valido_valor = false;
     			}else{
     				$("#txtUsuario").removeClass("is-invalid");
     				$("#txtUsuario").parent().find("span").html("");
     				usuario_valido_valor = true;
     			}
     		},
     		error: function(data){
     			$("#txtUsuario").addClass("is-invalid");
     			$("#txtUsuario").parent().find("span").html("Error: No se podido validar si el usuario está en uso");
     			usuario_valido_valor = false;
     		}
     	});
     	this.model.datos_generales_valido = usuario_valido_valor;
	},
	validarContraseniaAntigua: function(event) {
		var usuario_valido_valor;
		var usuario_temp = new Object();
	  usuario_temp.id = this.model.id.toString();
	  usuario_temp.contrasenia  = $("#txtContraseniaAntgua").val();
    $.ajax({
      type: "POST",
      url: BASE_URL + "usuario/contrasenia_repetida",
      data: {
        data:JSON.stringify(usuario_temp),
      },
      headers: {
        [CSRF_KEY]: CSRF,
      },
      async: false,
      success: function(data){
        if(data == 0){
          $("#txtContraseniaAntgua").addClass("is-invalid");
          $("#txtContraseniaAntgua").parent().find("span").html("La contraseña ingresada no coincide");
          contrasenia_valido_valor = false;
        }else{
          $("#txtContraseniaAntgua").removeClass("is-invalid");
          $("#txtContraseniaAntgua").parent().find("span").html("");
          contrasenia_valido_valor = true;
        }
      },
      error: function(data){
        $("#txtContraseniaAntgua").addClass("is-invalid");
        $("#txtContraseniaAntgua").parent().find("span").html("Error: No se podido validar si la contraseña antigua");
        contrasenia_valido_valor = false;
      }
    });
    this.model.datos_contrasenias_valido = contrasenia_valido_valor;
	},
	validarUsuarioLleno: function(event) {
		if(this.model.usuario_valido != false){
			if($("#txtUsuario").val() == ""){
				$("#txtUsuario").addClass("is-invalid");
	      	$("#txtUsuario").parent().find("span").html("Debe ingresar un usuario");
	      	this.model.datos_generales_valido = false;
			}else{
				$("#txtUsuario").removeClass("is-invalid");
	      	$("#txtUsuario").parent().find("span").html("");
	      	this.model.datos_generales_valido = true;
			}
		}
	},
	validarCorreoRepetido: function(event) {
		var correo_valido_valor;
		var usuario_temp = new Object();
	  usuario_temp.id = this.model.id.toString();
	  usuario_temp.correo  = $("#txtCorreo").val(),
    $.ajax({
      type: "POST",
      url: BASE_URL + "usuario/correo_repetido",
      data: {
        data: JSON.stringify(usuario_temp)
      }, //"data=" + JSON.stringify(usuario_temp),
      headers: {
        [CSRF_KEY]: CSRF,
      },
      async: false,
      success: function(data){
        if(data >= 1){
          $("#txtCorreo").addClass("is-invalid");
          $("#txtCorreo").parent().find("span").html("El correo ya se encuentra asociado a un usuario registrado");
          correo_valido_valor = false;
        }else{
          $("#txtCorreo").removeClass("is-invalid");
          $("#txtCorreo").parent().find("span").html("");
          correo_valido_valor = true;
        }
      },
      error: function(data){
        $("#txtCorreo").addClass("is-invalid");
        $("#txtCorreo").parent().find("span").html("Error: No se podido validar si el correo está en uso");
        correo_valido_valor = false;
      }
    });
    this.model.datos_generales_valido = correo_valido_valor;
	},
	validarCorreoLleno: function(event) {
		if($("#txtCorreo").val() == ""){
			$("#txtCorreo").addClass("is-invalid");
     		$("#txtCorreo").parent().find("span").html("Tiene que ingresar un correo");
     		this.model.datos_generales_valido = false;
		}
	}, 
	validarContraseniaLleno: function(event) {
		if($("#txtContraseniaAntgua").val() == ""){
			$("#txtContraseniaAntgua").addClass("is-invalid");
     		$("#txtContraseniaAntgua").parent().find("span").html("Tiene que ingresar su contraseña");
     		this.model.datos_contrasenias_valido = false;
		}else{
			$("#txtContraseniaAntgua").removeClass("is-invalid");
     		$("#txtContraseniaAntgua").parent().find("span").html("");
     		this.model.datos_contrasenias_valido = true;
		}
	}, 	
	validarContraseniaAntiguaDiferente: function(event){
		this.validarContraseniaLleno();
		if($("#txtContraseniaAntgua").val() == $("#txtContraseniaNueva").val()){
			$("#txtContraseniaNueva").addClass("is-invalid");
     		$("#txtContraseniaNueva").parent().find("span").html("La nueva contraseña no puede coincidir con la primera");
     		this.model.datos_contrasenias_valido = false;
		}else{
			$("#txtContraseniaNueva").removeClass("is-invalid");
     		$("#txtContraseniaNueva").parent().find("span").html("");
     		this.model.datos_contrasenias_valido = true;
		}
	}, 
	validarContraseniaIgual: function(event) {
		this.validarContraseniaLleno();
		if($("#txtContraseniaNueva").val() != $("#txtContraseniaNuevaRepetida").val()){
			$("#txtContraseniaNuevaRepetida").addClass("is-invalid");
     		$("#txtContraseniaNuevaRepetida").parent().find("span").html("La contraseña ingresada no coincide con la primera");
     		this.model.datos_contrasenias_valido = false;
		}else{
			$("#txtContraseniaNuevaRepetida").removeClass("is-invalid");
     		$("#txtContraseniaNuevaRepetida").parent().find("span").html("");
     		this.model.datos_contrasenias_valido = true;
		}
	}, 
	validarContraseniaRepetidoLleno: function(event) {
		if($("#txtContraseniaNueva").val() == ""){
			$("#txtContraseniaNueva").addClass("is-invalid");
     		$("#txtContraseniaNueva").parent().find("span").html("Tiene que confirmar la contrasña ingresada");
     		this.model.contrasenia_valido = false;
		}
	}, 
	validarCorreoFormato: function(event) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var rpta = re.test($("#txtCorreo").val());
    if(rpta == false){
    $("#txtCorreo").addClass("is-invalid");
      $("#txtCorreo").parent().find("span").html("El correo ingresado no es de un formato válido");
      this.model.correo_valido = false;
    }else{
    $("#txtCorreo").removeClass("is-invalid");
      $("#txtCorreo").parent().find("span").html("");
      this.model.correo_valido = true;
    }
	}, 
	guardarUsuarioCorreo: function(event){
		this.validarUsuarioRepetido();
		this.validarCorreoRepetido();
		this.validarUsuarioLleno();
		this.validarCorreoLleno();
		//this.model.validar();
		if(this.model.datos_generales_valido == true){
			//console.log(this.model.toJSON());
			$.ajax({
        type: "POST",
        url: BASE_URL + "usuario/guardar_usuario_correo",
        data: {
          usuario : JSON.stringify(this.datosGeneralesToJSON())
        },
        headers: {
					[CSRF_KEY]: CSRF,
				},
        async: false,
        success: function(data){
          var rpta = JSON.parse(data);
          if(rpta['tipo_mensaje'] == "error"){
            $("#txtMensajeRptaUsuarioDetalle").removeClass("color-success");
            $("#txtMensajeRptaUsuarioDetalle").addClass("color-rojo");
            $("#txtMensajeRptaUsuarioDetalle").html(rpta['mensaje'][0]);
            correo_valido_valor = false;
          }else{
            $("#txtMensajeRptaUsuarioDetalle").removeClass("color-rojo");
            $("#txtMensajeRptaUsuarioDetalle").addClass("color-success");
            $("#txtMensajeRptaUsuarioDetalle").html(rpta['mensaje'][0]);
            correo_valido_valor = true;
          }
        },
        error: function(data){
          //FALTA MANEJAR EL ERROR DEL AJAX
        }
      });
		}else{
			
		}
  },
  datosGeneralesToJSON: function() {
    var usuario = new Object();
    usuario.id = this.model.id.toString();
    usuario.usuario = $("#txtUsuario").val();
    usuario.correo = $("#txtCorreo").val();
    usuario.estado_usuario_id = $("#cbmEstado").val();
    return usuario;
  },
	cambiarContrasenia: function(event){
		//this.validarContraseniaIgual();
		this.validarContraseniaAntigua();
		this.validarContraseniaAntiguaDiferente();
		this.validarContraseniaIgual();
		this.validarContraseniaLleno();
		//this.model.validar();
		if(this.model.datos_contrasenias_valido == true){
			$.ajax({
        type: "POST",
        url: BASE_URL + "usuario/guardar_contrasenia",
        data: {
          contrasenia: JSON.stringify(this.datosContraseniasToJSON())
        },
        headers: {
					[CSRF_KEY]: CSRF,
				},
        async: false,
        success: function(data){
          var rpta = JSON.parse(data);
          if(rpta['tipo_mensaje'] == "error"){
            $("#txtMensajeRptaUsuarioContrasenia").removeClass("color-success");
            $("#txtMensajeRptaUsuarioContrasenia").addClass("color-rojo");
            $("#txtMensajeRptaUsuarioContrasenia").html(rpta['mensaje'][0]);
            correo_valido_valor = false;
          }else{
            $("#txtMensajeRptaUsuarioContrasenia").removeClass("color-rojo");
            $("#txtMensajeRptaUsuarioContrasenia").addClass("color-success");
            $("#txtMensajeRptaUsuarioContrasenia").html(rpta['mensaje'][0]);
            correo_valido_valor = true;
          }
        },
        error: function(data){
          //FALTA MANEJAR EL ERROR DEL AJAX
        }
      });
		}else{
			
		}
  },
  datosContraseniasToJSON: function() {
    var usuario = new Object();
    usuario.id = this.model.id.toString();
    usuario.contrasenia = $("#txtContraseniaNueva").val();
    return usuario;
  },
});