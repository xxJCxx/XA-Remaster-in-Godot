extends Control

@onready var Fondo_Borroso = $CanvasLayer / Fondo_Borroso
var activo = false
var config = ConfigFile.new()

func actualizar_sfx():
	if get_tree().get_nodes_in_group("Sfx_node"):
		for node in get_tree().get_nodes_in_group("Sfx_node"):
			node.actualizar()

func actualizar_musica():
	if get_tree().get_nodes_in_group("Music_node"):
		for node in get_tree().get_nodes_in_group("Music_node"):
			node.actualizar()

func mostrar():
	activo = true
	global_position = Vector2(0, 0)
	$CanvasLayer.show()
func ocultar():
	activo = false
	global_position = Vector2(0, 1100)
	$CanvasLayer.hide()

func _ready() -> void :
	config.load("user://config.cfg")
	$CanvasLayer / Menu / HSlider_musica.value = config.get_value("volumen", "vol_musica")
	$CanvasLayer / Menu / HSlider_sfx.value = config.get_value("volumen", "vol_sfx")
	$CanvasLayer / Menu / Sfx.button_pressed = config.get_value("volumen", "sfx")
	$CanvasLayer / Menu / Musica.button_pressed = config.get_value("volumen", "musica")
	$CanvasLayer / Menu / Pantalla_completa.button_pressed = config.get_value("video", "pantalla_completa")

func cambiar_modo_ventana(opcion):
	var configuracion = ConfigFile.new()
	configuracion.load("user://config.cfg")
	configuracion.set_value("video", "pantalla_completa", opcion)
	configuracion.save("user://config.cfg")
	if configuracion.get_value("video", "pantalla_completa"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_h_slider_musica_value_changed(value: float) -> void :
	config.set_value("volumen", "vol_musica", $CanvasLayer / Menu / HSlider_musica.value)
	config.save("user://config.cfg")
	actualizar_musica()

func _on_musica_pressed() -> void :
	Input.vibrate_handheld(30, 0.5)
	$sfx_node.play()
	config.set_value("volumen", "musica", $CanvasLayer / Menu / Musica.button_pressed)
	config.save("user://config.cfg")
	actualizar_musica()

func _on_sfx_pressed() -> void :
	Input.vibrate_handheld(30, 0.5)
	$sfx_node.play()
	config.set_value("volumen", "sfx", $CanvasLayer / Menu / Sfx.button_pressed)
	config.save("user://config.cfg")
	actualizar_sfx()


func _on_h_slider_sfx_value_changed(value: float) -> void :
	config.set_value("volumen", "vol_sfx", $CanvasLayer / Menu / HSlider_sfx.value)
	config.save("user://config.cfg")
	actualizar_sfx()


func _on_pantalla_completa_pressed() -> void :
	Input.vibrate_handheld(30, 0.5)
	$sfx_node.play()
	cambiar_modo_ventana($CanvasLayer / Menu / Pantalla_completa.button_pressed)


func _on_atras_pressed() -> void :
	Input.vibrate_handheld(30, 0.5)
	$sfx_node.play()
	activo = false
	ocultar()
