extends Node2D

var daño = 1

var vel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func hit_player():
	$Area2D/Sprite2D.visible = false
	$Area2D/Sprite2D3.visible = true
	$AnimationPlayer.play("hit enemy")
	$Area2D/AudioStreamPlayer2D.play()
	vel = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vel < 0:
		$Area2D/Sprite2D2.offset.x = 10
		$Area2D/Sprite2D2.flip_h = false
	elif vel > 0:
		$Area2D/Sprite2D2.offset.x = -10
		$Area2D/Sprite2D2.flip_h = true
	if $Timer.time_left == 0:
		queue_free()
	position.x += vel

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2)
		hit_player()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("take_damage"):
		pass
	else:
		vel = 0
		$Area2D/Sprite2D.visible = false
		$Area2D/Sprite2D2.visible = true
		$AnimationPlayer.play("hit_wall")
		if randi_range(1,2) == 1:
			$Area2D/AudioStreamPlayer2D.play()
		else:
			$Area2D/AudioStreamPlayer2D2.play()
