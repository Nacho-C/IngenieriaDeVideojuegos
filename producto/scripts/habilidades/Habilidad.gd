extends Resource

class_name habilidad

export var nombre : String
export var costo : int
export(String,"respeto","talento","creatividad","autoestima","dedosRapidos") var statBase
export var multiplicador : float
export(String,"respeto","talento","creatividad","autoestima","dedosRapidos","timer") var statObjetivo
export(String,"aliados","enemigos") var equipoAfectado

func getNombre():
	return self.nombre

func getEquipoAfectado():
	match equipoAfectado:
		"aliados": return 1
		"enemigos": return 2

func getCosto():
	return costo

func ejecutar(fuente,objetivo):
	var monto
	match statBase:
		"respeto": monto = fuente.getRespeto()
		"talento": monto = fuente.getTalento()
		"creatividad": monto = fuente.getCreatividad()
		"autoestima": monto = fuente.getAutoestima()
		"dedosRapidos": monto = fuente.getDedosRapidos()
	monto = monto * multiplicador
	objetivo.alterarStat(monto,statObjetivo)
