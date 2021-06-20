extends Node2D

var personaje
var equipo
var cero

func init(equipo,ceroRelativo):
	self.equipo = equipo
	self.cero = ceroRelativo
	if equipo == 1:
		$Sprite.position = Vector2(-21,0)
		$Sprite.rotation = 115 * PI/180
	else:
		$Sprite.position = Vector2(21,0)
		$Sprite.rotation = 295 * PI/180

func setPersonaje(personaje):
	if (self.personaje != null):
		self.personaje.setActivadoBoton(1)
	self.personaje = personaje
	self.personaje.setActivadoBoton(2)
	self.position = personaje.getPosicionFlecha() + self.cero

func getPersonaje():
	return self.personaje
