extends Node2D

var posEquipo1 = Vector2(250,420)
var posEquipo2 = Vector2(1030,420)

var res_inventarioHabilidades = load("res://scripts/habilidades/inventarioHabilidades.tscn")
var res_cursor = load("res://scripts/encuentros/cursor.tscn")
var dialogo = load("res://scripts/encuentros/dialogoEncuentro.tscn").instance()
var cursor
var musica
var equipo1
var respeto1
var equipo2
var respeto2
var personajeTurno
var inventarioTurno
var habilidadSeleccionada

signal bastaParaTodos
signal chanchoArriba

#Inicializa el encuentro
func init(fondo,musica,e1,e2):
	#Setea el fondo del encuentro
	self.texture = fondo
	self.musica = musica
	
	#Inicializa el botón de pausa
	self.connect("bastaParaTodos",$Pausa/BotonPausa,"desactivar")
	self.connect("chanchoArriba",$Pausa/BotonPausa,"activar")
	
	#Agrega e inicializa equipo 1
	equipo1 = e1
	add_child(equipo1)
	equipo1.setDireccion(1)
	equipo1.position = posEquipo1
	for p in e1.getPersonajes():
		p.setEquipo(1)
		p.connect("bastaParaMi",self,"comenzarTurno",[p])
		p.connect("seleccionado",self,"moverCursor",[p])
		p.connect("terminarTurno",self,"terminarTurno",[p])
		self.connect("bastaParaTodos",p,"detenerTimer")
		self.connect("chanchoArriba",p,"retomarTimer")
	$Respeto1.value = 0
	$Respeto1.rect_position = posEquipo2 + Vector2(-128,-380)
	
	#Agrega e inicializa equipo 2
	equipo2 = e2
	add_child(equipo2)
	equipo2.setDireccion(2)
	equipo2.position = posEquipo2
	for p in e2.getPersonajes():
		p.setEquipo(2)
		p.connect("bastaParaMi",self,"comenzarTurno",[p])
		p.connect("seleccionado",self,"moverCursor",[p])
		p.connect("terminarTurno",self,"terminarTurno",[p])
		self.connect("bastaParaTodos",p,"detenerTimer")
		self.connect("chanchoArriba",p,"retomarTimer")
	$Respeto2.value = 0
	$Respeto2.rect_position = posEquipo1 + Vector2(-128,-380)
	
	#Comienza el encuentro
	dialogo.init()
	add_child(dialogo)
	dialogo.position = Vector2(640,540)
	yield(dialogo.mostrar("¡Que comience el encuentro!"),"completed")
	get_node("/root/Sonidos").empezarMusica(musica)
	emit_signal("chanchoArriba")

#Llamado cuando el timer de un personae llega a 100
func comenzarTurno(source):
	personajeTurno = source
	emit_signal("bastaParaTodos")
	yield(dialogo.mostrar(str("Es el turno de ",personajeTurno.getNombre(),".")),"completed")
	personajeTurno.position = personajeTurno.position + Vector2(100*personajeTurno.getDireccion(),0)
	if (personajeTurno.getEquipo() == 1):
		mostrarInventarios()
	else:
		turnoIA()

#Secuencia para el turno de un personaje no controlado por el usuario
func turnoIA():
	var rng = RandomNumberGenerator.new()
	var habilidades = personajeTurno.getHabilidades()
	var personajes
	var rango = habilidades.size() - 1
	var personajeSeleccionado
	rng.randomize()
	habilidadSeleccionada = habilidades[rng.randi_range(0,rango-1)]
	if (habilidadSeleccionada.getCosto() > personajeTurno.getCreatividad()):
		personajeSeleccionado = personajeTurno
		habilidadSeleccionada = habilidades[rango]
	else:
		if (habilidadSeleccionada.getEquipoAfectado() == 2):
			personajes = equipo1.getPersonajes()
		else:
			personajes = equipo2.getPersonajes()
		rango = personajes.size() - 1
		personajeSeleccionado = personajes[rng.randi_range(0,rango)] 
	terminarTurno(personajeSeleccionado)

#Muestra el inventario de habilidades del personaje a utilizar
func mostrarInventarios():
	inventarioTurno = res_inventarioHabilidades.instance()
	inventarioTurno.position = Vector2(640,540)
	inventarioTurno.init(personajeTurno,self)
	add_child(inventarioTurno)

#Muestra los personajes seleccionables para la habilidad seleccionada
func mostrarObjetivos(habilidad):
	get_node("/root/Sonidos").click()
	self.habilidadSeleccionada = habilidad
	remove_child(inventarioTurno)
	inventarioTurno.queue_free()
	if (habilidad.getNombre() == "Saltar turno"):
		terminarTurno(personajeTurno)
	else:
		cursor = res_cursor.instance()
		if (habilidad.getEquipoAfectado() == 1):
			cursor.init(1,equipo1.position)
			for p in equipo1.getPersonajes():
				p.setActivadoBoton(1)
			cursor.setPersonaje(equipo1.getPersonajes()[0])
		else:
			cursor.init(2,equipo2.position)
			for p in equipo2.getPersonajes():
				p.setActivadoBoton(1)
			cursor.setPersonaje(equipo2.getPersonajes()[0])
		add_child(cursor)

#Posiciona el cursor en el personaje tocado
func moverCursor(personajeSeleccionado):
	cursor.setPersonaje(personajeSeleccionado)

#Ejecuta la habilidad y prepara el encuentro para el próximo turno
func terminarTurno(personajeSeleccionado):
	var mensaje = personajeTurno.getNombre()
	var monto
	
	if (cursor != null):
		remove_child(cursor)
		cursor.queue_free()
		cursor = null
	
	if (personajeTurno.getEquipo() == 1):
		for p in equipo1.getPersonajes():
				p.setActivadoBoton(0)
		for p in equipo2.getPersonajes():
				p.setActivadoBoton(0)
	
	if (habilidadSeleccionada.getNombre() == "Saltar turno"):
		mensaje = str(mensaje," pasa su turno para ahorrar Creatividad.")
	else:
		mensaje = str(mensaje," usa ", habilidadSeleccionada.getNombre()," en ", personajeSeleccionado.getNombre(),".")
	yield(dialogo.mostrar(mensaje),"completed")
	
	monto = yield(personajeTurno.usarHabilidad(personajeSeleccionado,habilidadSeleccionada),"completed")
	if (habilidadSeleccionada.getNombre() != "Saltar turno"):
		if (monto == 0):
			mensaje = "¡La habilidad no tuvo efecto!"
		else:
			if (habilidadSeleccionada.getStatObjetivo() == "Respeto"):
				yield(actualizarRespeto(personajeSeleccionado.getEquipo()),"completed")
				mensaje = str("¡El respeto por ",personajeTurno.getNombre()," sube en ")
			else:
				mensaje = str("¡",habilidadSeleccionada.getStatObjetivo()," de ", personajeSeleccionado.getNombre())
				if (habilidadSeleccionada.getMultiplicador() < 0):
					mensaje = str(mensaje," baja en ")
				else:
					mensaje = str(mensaje," sube en ")
			mensaje = str(mensaje,abs(monto)," puntos!")
		yield(dialogo.mostrar(mensaje),"completed")
	personajeTurno.position = personajeTurno.position + Vector2(-100*personajeTurno.getDireccion(),0)
	if (respeto1 == 100):
		terminarEncuentro(2)
	elif (respeto2 == 100):
		terminarEncuentro(1)
	else:
		personajeTurno.comenzarTimer()
		emit_signal("chanchoArriba")

func actualizarRespeto(equipo):
	if (equipo == 1):
		respeto1 = equipo1.getRespeto()
		yield(animarRespeto(1),"completed")
	else:
		respeto2 = equipo2.getRespeto()
		yield(animarRespeto(2),"completed")

func animarRespeto(equipo):
	var paso
	var barra
	var respeto
	if (equipo == 1):
		barra = $Respeto1
		respeto = respeto1
	else:
		barra = $Respeto2
		respeto = respeto2
	paso = (respeto - barra.value) / 25
	while (barra.value < respeto):
		barra.value += paso
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

func terminarEncuentro(equipoGanador):
	var mensaje
	get_node("/root/Sonidos").pararMusica()
	emit_signal("bastaParaTodos")
	$Pausa/BotonPausa.desactivar()
	if (equipoGanador == 1):
		mensaje = "¡El equipo de Astor Piazzola gana el encuentro!"
	else:
		mensaje = "¡El equipo de Astor Piazzola pierde el encuentro!"
	yield(dialogo.mostrar(mensaje),"completed")
	#GUARDA BORRAR ESTO
	get_tree().paused = true
