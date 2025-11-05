extends Control

var intro


func _ready() -> void :
    intro = ResourceLoader.load("res://assets/data/Menus/intro.tscn")
    $Timer.start()
    var save_file = JSON.new()
    var config = ConfigFile.new()
    save_file = ResourceLoader.load("res://save/save_data.json")
    if not ResourceLoader.exists("user://save_data.json"):
        save_file = ResourceLoader.load("res://save/save_data.json")
        ResourceSaver.save(save_file, "user://save_data.json")
    var err = config.load("user://config.cfg")
    if err != OK:
        config.load("res://config/config.cfg")
        config.save("user://config.cfg")
    if config.get_value("video", "pantalla_completa"):
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_timer_timeout() -> void :
    get_tree().change_scene_to_packed(intro)
