extends Node2D

const posEquipo1 = Vector2(320,360)
const posEquipo2 = Vector2(960,360)

#BORRAR ESTO
var personajeSeleccionado

var res_inventarioHabilidades = load("res://scripts/habilidades/inventarioHabilidades.tscn")
var equipo1
var equipo2
var turnoEnProceso
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
		p.connect("bastaParaMi",self,"iniciarTurno",[p])
		self.connect("bastaParaTodos",p,"detenerTimer")
		self.connect("chanchoArriba",p,"retomarTimer")
		
	#Agrego e inicializo equipo 2
	equipo2 = e2
	add_child(equipo2)
	equipo2.setDireccion(2)
	equipo2.position = posEquipo2
	for p in e2.getPersonajes():
		p.connect("bastaParaMi",self,"iniciarTurno",[p])
		self.connect("bastaParaTodos",p,"detenerTimer")
		self.connect("chanchoArriba",p,"retomarTimer")
		personajeSeleccionado = p
	turnoEnProceso = false

func iniciarTurno(source):
	turnoEnProceso = true
	personajeTurno = source
	emit_signal("bastaParaTodos")
	personajeTurno.position = personajeTurno.position + Vector2(50*personajeTurno.getDireccion(),0)
	#GUARDA CON ESTO
	if (personajeTurno.getNombre() == "Astor"):
		inventarioTurno = res_inventarioHabilidades.instance()
		inventarioTurno.position = Vector2(640,540)
		inventarioTurno.init(personajeTurno.getHabilidades(),self)
		add_child(inventarioTurno)

func terminarTurno(habilidad):
	if (turnoEnProceso):
		#GUARDA CON ESTO
		if (personajeTurno.getNombre() == "Astor"):
			personajeTurno.usarHabilidad(personajeSeleccionado,habilidad)
			remove_child(inventarioTurno)
		personajeTurno.position = personajeTurno.position + Vector2(-50*personajeTurno.getDireccion(),0)
		personajeTurno.comenzarTimer()
		emit_signal("chanchoArriba")
		turnoEnProceso = false
