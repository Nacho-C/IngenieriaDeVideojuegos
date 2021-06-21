extends AudioStreamPlayer

var click = load("res://assets/sounds/toque.wav")

func click():
	self.stream = click
	self.play()
