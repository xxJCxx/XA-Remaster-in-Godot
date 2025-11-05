extends AudioStreamPlayer

var config = ConfigFile.new()

func actualizar():
	config.load("user://config.cfg")
	if config.get_value("volumen", "musica") == true:
		volume_db = -80 / db_to_linear(config.get_value("volumen", "vol_musica"))
	else:
		volume_db = -80
func _ready() -> void :
	actualizar()
