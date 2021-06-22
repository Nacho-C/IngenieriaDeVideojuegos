extends TouchScreenButton

var activado
var filtro
var res_despausa = preload("res://assets/img/UI/botonDespausa.png")
var res_pausaActivado = preload("res://assets/img/UI/botonPausaActivado.png")
var res_pausaDesactivado = preload("res://assets/img/UI/botonPausaDesactivado.png")

func _ready():
	self.connect("released",self,"tocado")
	activado = false
	filtro = get_parent().get_node("FiltroPausa")

func tocado():
	if (activado):
		get_node("/root/Sonidos").click()
		if (get_tree().paused == true):
			set_texture(res_pausaActivado)
			filtro.set_visible(false)
			get_node("/root/Sonidos").seguirMusica()
			get_tree().paused = false
		else:
			set_texture(res_despausa)
			filtro.set_visible(true)
			get_node("/root/Sonidos").pararMusica()
			get_tree().paused = true

func activar():
	activado = true
	set_texture(res_pausaActivado)

func desactivar():
	activado = false
	set_texture(res_pausaDesactivado)
