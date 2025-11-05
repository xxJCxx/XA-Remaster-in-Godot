extends Control

var save = preload("res://save/save_data.json")
@export var Intro2 = false
var press = false
@export var Intro = false
var Diapositiva = -1


func _input(_event) -> void :
	if Input.is_action_just_pressed("Pausa"):
		get_tree().change_scene_to_file("res://assets/data/Menus/load_menu_principal.tscn")

func _ready() -> void :
	ResourceSaver.save(save, "user://save_data.json")
	print(OS.get_user_data_dir())
	var config = ConfigFile.new()
	config.load("res://config/config.cfg")
	config.save("user://config.cfg")
	$MusicaIntro.actualizar()
	$sfx_piano.actualizar()
	$Animaciones.play("Intro")



func play_anim2():
	Intro = true;
	Diapositiva += 1


func _process(delta: float) -> void :
	if Input.is_anything_pressed() and Intro == false and Intro2 == true:
		Intro = true;

	if Input.is_anything_pressed() and Intro == true and press == false:
		Diapositiva += 1
		press = true
	elif not Input.is_anything_pressed():
		press = false

	if Diapositiva == 0 and Intro == true:
		Intro = false
		$Animaciones.play("Diap1")
	if Diapositiva == 1 and Intro == true:
		Intro = false
		$Animaciones.play("Diap2")
	if Diapositiva == 2 and Intro == true:
		Intro = false
		$Animaciones.play("Diap3")
	if Diapositiva == 3 and Intro == true:
		Intro = false
		$Animaciones.play("Diap4")
	if Diapositiva == 4 and Intro == true:
		Intro = false
		$Animaciones.play("Diap5")
	if Diapositiva == 5 and Intro == true:
		get_tree().change_scene_to_file("res://assets/data/Menus/load_menu_principal.tscn")
