extends Node2D

const posEquipo1 = Vector2(320,360)
const posEquipo2 = Vector2(960,360)

#BORRAR ESTO
var congelar = load("res://assets/habilidades/congelar.tres")
var descongelar = load("res://assets/habilidades/descongelar.tres")
var personajeSeleccionado

var equipo1
var equipo2
var turnoEnProceso
var personajeTurno
var sePresionoBoton
var habilidadSeleccionada

signal bastaParaTodos
signal chanchoArriba

func init(e1,e2):
	$BotonCongelar.connect("released",self,"terminarTurno",["congelar"])
	$BotonDescongelar.connect("released",self,"terminarTurno",["descongelar"])
	
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
	
func terminarTurno(habilidadBoton):
	if (turnoEnProceso):
		match habilidadBoton:
			"congelar": habilidadSeleccionada = congelar
			"descongelar": habilidadSeleccionada = descongelar
		if (personajeTurno.getNombre() == "Astor"):
			personajeTurno.usarHabilidad(personajeSeleccionado,habilidadSeleccionada)
		personajeTurno.position = personajeTurno.position + Vector2(-50*personajeTurno.getDireccion(),0)
		personajeTurno.comenzarTimer()
		emit_signal("chanchoArriba")
		turnoEnProceso = false
