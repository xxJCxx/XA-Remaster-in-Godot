extends Node2D

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player.velocity.x == 0:
		$AnimationPlayer.play("doble_salto_vertical")
		$Sprite2D.show()
	else:
		if player.dir == 1:
			$Sprite2D2.flip_h = false
		elif player.dir == -1:
			$Sprite2D2.flip_h = true
		$Sprite2D2.show()
		$AnimationPlayer.play("doble_salto_horizontal")
