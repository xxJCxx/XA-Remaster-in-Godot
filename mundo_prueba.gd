extends Node2D

var monedas

func _ready():
	monedas = get_tree().get_nodes_in_group("monedas").size()


func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	player.porcentaje_monedas = player.monedas * 100 / monedas
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
