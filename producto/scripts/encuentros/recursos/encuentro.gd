extends Resource

class_name encuentro

export var musica : AudioStreamMP3
export var fondo : Texture
export var rivales : Array
export var dialogoInicial : Array
export var dialogoFinal : Array
export var personajePremio : PackedScene

func getRivales():
	return rivales

func getFondo():
	return fondo

func getMusica():
	return musica

func getPremio():
	return personajePremio

func getInicio():
	return dialogoInicial

func getFinal():
	return dialogoFinal
