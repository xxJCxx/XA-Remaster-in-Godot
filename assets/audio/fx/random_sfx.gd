extends "res://assets/audio/fx/sfx_node.gd"

@export_file("*.ogg") var sfx_array: Array[String]

func play_random_sfx():
    var r = randi_range(0, sfx_array.size() - 1)
    stream = ResourceLoader.load(sfx_array[r])
    play()
