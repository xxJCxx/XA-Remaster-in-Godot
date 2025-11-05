extends Control

var intro

func _ready() -> void :
    $SpriteScene / Sprite_cargando.play("default")
    $Timer.start()

func _on_timer_timeout() -> void :
    intro = ResourceLoader.load("res://assets/data/Menus/menu_principal.tscn")
    get_tree().change_scene_to_packed(intro)
