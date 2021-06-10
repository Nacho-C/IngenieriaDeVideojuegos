extends Node2D

const posEquipo1 = Vector2(320,360)
const posEquipo2 = Vector2(960,360)

var res_inventarioHabilidades = load("res://scripts/habilidades/inventarioHabilidades.tscn")
var res_cursor = load("res://scripts/encuentros/cursor.tscn")
var cursor
var equipo1
var equipo2
var personajeTurno
var inventarioTurno
var sePresionoBoton
var habilidadSeleccionada

signal bastaParaTodos
signal chanchoArriba

func init(e1,e2):	
	#Agrego e inicializo equipo 1
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
	
	#Agrego e inicializo equipo 2
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

func comenzarTurno(source):
	personajeTurno = source
	emit_signal("bastaParaTodos")
	personajeTurno.position = personajeTurno.position + Vector2(50*personajeTurno.getDireccion(),0)
	if (personajeTurno.getEquipo() == 1):
		mostrarInventarios()
	else:
		turnoIA()

func turnoIA():
	var rng = RandomNumberGenerator.new()
	var habilidades = personajeTurno.getHabilidades()
	var personajes
	var rango = habilidades.size() - 1
	var personajeSeleccionado
	rng.randomize()
	habilidadSeleccionada = habilidades[rng.randi_range(0,rango)]
	print(habilidadSeleccionada.getNombre())
	if (habilidadSeleccionada.getNombre() != "Saltar turno"):
		if (habilidadSeleccionada.getEquipoAfectado() == 2):
			personajes = equipo1.getPersonajes()
		else:
			personajes = equipo2.getPersonajes()
		rango = personajes.size() - 1
		personajeSeleccionado = personajes[rng.randi_range(0,rango)] 
		print("Personaje elegido: ",personajeSeleccionado.getNombre())
	else:
		personajeSeleccionado = personajeTurno
	terminarTurno(personajeSeleccionado)

func mostrarInventarios():
	inventarioTurno = res_inventarioHabilidades.instance()
	inventarioTurno.position = Vector2(640,540)
	inventarioTurno.init(personajeTurno.getHabilidades(),self)
	add_child(inventarioTurno)

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
				cursor.setPersonaje(p)
		else:
			cursor.init(2,equipo2.position)
			for p in equipo2.getPersonajes():
				p.setActivadoBoton(1)
				cursor.setPersonaje(p)
		add_child(cursor)

func moverCursor(personajeSeleccionado):
	cursor.setPersonaje(personajeSeleccionado)

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
