extends Node2D

var personaje
var equipo
var cero

func init(equipo,ceroRelativo):
	self.equipo = equipo
	self.cero = ceroRelativo
	if equipo == 1:
		$Sprite.set_flip_h(false)
	else:
		$Sprite.set_flip_h(true)

func setPersonaje(personaje):
	if (self.personaje != null):
		self.personaje.setActivadoBoton(1)
	self.personaje = personaje
	self.personaje.setActivadoBoton(2)
	self.position = personaje.getPosicionFlecha() + self.cero

func getPersonaje():
	return self.personaje
