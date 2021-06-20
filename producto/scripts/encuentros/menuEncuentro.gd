extends Node2D

var posEquipo1 = Vector2(320,360)
var posEquipo2 = Vector2(960,360)

var res_inventarioHabilidades = load("res://scripts/habilidades/inventarioHabilidades.tscn")
var res_cursor = load("res://scripts/encuentros/cursor.tscn")
var cursor
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
func init(fondo,e1,e2):
	#Setea el fondo del encuentro
	self.texture = fondo
	
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
	$Respeto1.rect_position = posEquipo2 + Vector2(-128,-320)
	
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
	$Respeto2.rect_position = posEquipo1 + Vector2(-128,-320)
	
	#Comienza el encuentro
	emit_signal("chanchoArriba")

#Llamado cuando el timer de un personae llega a 100
func comenzarTurno(source):
	personajeTurno = source
	emit_signal("bastaParaTodos")
	personajeTurno.position = personajeTurno.position + Vector2(50*personajeTurno.getDireccion(),0)
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
	print(habilidadSeleccionada.getNombre())
	if (habilidadSeleccionada.getCosto() > personajeTurno.getCreatividad()):
		print("No tiene creatividad.")
		personajeSeleccionado = personajeTurno
		habilidadSeleccionada = habilidades[rango]
	else:
		if (habilidadSeleccionada.getEquipoAfectado() == 2):
			personajes = equipo1.getPersonajes()
		else:
			personajes = equipo2.getPersonajes()
		rango = personajes.size() - 1
		personajeSeleccionado = personajes[rng.randi_range(0,rango)] 
		print("Personaje elegido: ",personajeSeleccionado.getNombre())
	terminarTurno(personajeSeleccionado)

#Muestra el inventario de habilidades del personaje a utilizar
func mostrarInventarios():
	inventarioTurno = res_inventarioHabilidades.instance()
	inventarioTurno.position = Vector2(640,540)
	inventarioTurno.init(personajeTurno,self)
	add_child(inventarioTurno)

#Muestra los personajes seleccionables para la habilidad seleccionada
func mostrarObjetivos(habilidad):
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
	if (cursor != null):
		remove_child(cursor)
		cursor.queue_free()
		cursor = null
	if (personajeTurno.getEquipo() == 1):
		for p in equipo1.getPersonajes():
				p.setActivadoBoton(0)
		for p in equipo2.getPersonajes():
				p.setActivadoBoton(0)
	personajeTurno.usarHabilidad(personajeSeleccionado,self.habilidadSeleccionada)
	personajeTurno.position = personajeTurno.position + Vector2(-50*personajeTurno.getDireccion(),0)
	personajeTurno.comenzarTimer()
	emit_signal("chanchoArriba")
	actualizarRespeto()

func actualizarRespeto():
	respeto1 = equipo1.getRespeto()
	animarRespeto(1)
	respeto2 = equipo2.getRespeto()
	animarRespeto(2)
	#Si un equipo llega a 100 puntos de respeto, termina el encuentro
	if (respeto1 == 100):
		terminarEncuentro(2)
	elif (respeto2 == 100):
		terminarEncuentro(1)

func animarRespeto(equipo):
	var paso = 1/6
	var barra
	var respeto
	if (equipo == 1):
		barra = $Respeto1
		respeto = respeto1
	else:
		barra = $Respeto2
		respeto = respeto2
	if ((respeto - barra.value) > paso * 30):
		paso = (respeto - barra.value) / 30
	while (barra.value < respeto):
		barra.value += paso
		yield(get_tree(), "idle_frame")

func terminarEncuentro(equipoGanador):
	emit_signal("bastaParaTodos")
	print("Gana el equipo ",equipoGanador)
