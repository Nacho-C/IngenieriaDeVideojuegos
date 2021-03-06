extends Node2D

var posEquipo1 = Vector2(250,420)
var posEquipo2 = Vector2(1030,420)

var res_inventarioHabilidades = load("res://scripts/habilidades/inventarioHabilidades.tscn")
var res_cursor = load("res://scripts/encuentros/cursor.tscn")
var dialogo = load("res://scripts/dialogos/dialogoEncuentro.tscn").instance()
var cursor
var musica
var equipo1
var respeto1
var equipo2
var respeto2
var personajeTurno
var inventarioTurno
var habilidadSeleccionada
var animaciones
var solo

signal bastaParaTodos
signal chanchoArriba
signal ganado
signal perdido

#Inicializa el encuentro
func init(fondo,musica,e1,e2,solo):
	#Setea el fondo del encuentro
	self.texture = fondo
	self.musica = musica
	
	self.solo = solo
	
	#Inicializa el botón de pausa
	self.connect("bastaParaTodos",$Pausa/BotonPausa,"desactivar")
	self.connect("chanchoArriba",$Pausa/BotonPausa,"activar")
	
	#Agrega e inicializa equipo 1
	equipo1 = e1
	add_child(equipo1)
	equipo1.setDireccion(1)
	for p in e1.getPersonajes():
		p.setEquipo(1)
		p.connect("bastaParaMi",self,"comenzarTurno",[p])
		p.connect("seleccionado",self,"moverCursor",[p])
		p.connect("terminarTurno",self,"terminarTurno",[p])
		self.connect("bastaParaTodos",p,"detenerTimer")
		self.connect("chanchoArriba",p,"retomarTimer")
	if (!solo):
		equipo1.position = posEquipo1
		$Respeto1.value = 0
		$Respeto1.rect_position = posEquipo2 + Vector2(-128,-380)
		$Respeto1.set_visible(true)
	else:
		equipo1.position = Vector2(640,420)
		equipo1.setHorizontal()
	
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

func comenzar():
	#Comienza el encuentro
	dialogo.init()
	add_child(dialogo)
	dialogo.setPosicion(Vector2(640,540))
	yield(dialogo.mostrar("¡Que comience el encuentro!",null),"completed")
	get_node("/root/Sonidos").empezarMusica(musica)
	emit_signal("chanchoArriba")

#Llamado cuando el timer de un personae llega a 100
func comenzarTurno(source):
	personajeTurno = source
	animaciones = personajeTurno.getAnimaciones()
	emit_signal("bastaParaTodos")
	yield(dialogo.mostrar(str("Es el turno de ",personajeTurno.getNombre(),"."),null),"completed")
	if (personajeTurno.getEquipo() == 1):
		if (!solo):
			animaciones.play("caminarADerecha")
			yield(animaciones,"animation_finished")
			animaciones.play("idle")
		mostrarInventarios()
	else:
		animaciones.play("caminarAIzquierda")
		yield(animaciones,"animation_finished")
		animaciones.play("idle")
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
	if (rango == 0 || habilidadSeleccionada.getCosto() > personajeTurno.getCreatividad()):
		personajeSeleccionado = personajeTurno
		habilidadSeleccionada = habilidades[rango]
	else:
		cursor = res_cursor.instance()
		if (habilidadSeleccionada.getEquipoAfectado() == 2):
			personajes = equipo1.getPersonajes()
			cursor.init(1,equipo1.position)
		else:
			personajes = equipo2.getPersonajes()
			cursor.init(2,equipo2.position)
		rango = personajes.size() - 1
		personajeSeleccionado = personajes[rng.randi_range(0,rango)]
		add_child(cursor)
		get_node("/root/Sonidos").click()
		moverCursor(personajeSeleccionado)
		yield(get_tree().create_timer(1),"timeout")
		get_node("/root/Sonidos").click()
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
			moverCursor(equipo1.getPersonajes()[0])
			add_child(cursor)
		else:
			if (!solo):
				cursor.init(2,equipo2.position)
				for p in equipo2.getPersonajes():
					p.setActivadoBoton(1)
				moverCursor(equipo2.getPersonajes()[0])
				add_child(cursor)
			else:
				terminarTurno(equipo2.getPersonajes()[0])

#Posiciona el cursor en el personaje tocado
func moverCursor(personajeSeleccionado):
	if (personajeTurno.getEquipo() == 1):
		cursor.aliadoSetPersonaje(personajeSeleccionado)
	else:
		cursor.rivalSetPersonaje(personajeSeleccionado)

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
		mensaje = str(mensaje," usa ", habilidadSeleccionada.getNombre()," en ")
		if (personajeTurno != personajeSeleccionado):
			mensaje = str(mensaje,personajeSeleccionado.getNombre(),".")
		else:
			mensaje = str(mensaje,"sí mismo.")
	yield(dialogo.mostrar(mensaje,null),"completed")
	
	if (habilidadSeleccionada.getNombre() != "Saltar turno"):
		animaciones.play("habilidad")
		yield(animaciones,"animation_finished")
		animaciones.play("idle")
		monto = yield(personajeTurno.usarHabilidad(personajeSeleccionado,habilidadSeleccionada),"completed")
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
		yield(dialogo.mostrar(mensaje,null),"completed")
	else:
		monto = yield(personajeTurno.usarHabilidad(personajeSeleccionado,habilidadSeleccionada),"completed")
	if (!solo && personajeTurno.getEquipo() == 1):
		animaciones.play("volverDeDerecha")
		yield(animaciones,"animation_finished")
		animaciones.play("idle")
	else:
		animaciones.play("volverDeIzquierda")
		yield(animaciones,"animation_finished")
		animaciones.play("idle")
	
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
		yield(dialogo.mostrar(mensaje,null),"completed")
		emit_signal("ganado")
	else:
		mensaje = "¡El equipo de Astor Piazzola pierde el encuentro!"
		yield(dialogo.mostrar(mensaje,null),"completed")
		emit_signal("perdido")
