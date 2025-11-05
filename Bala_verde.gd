extends Node2D

var daño = 1

var vel = 7.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit_enemy():
	$CharacterBody2D/Area2D/Sprite2D.visible = false
	$CharacterBody2D/Area2D/Sprite2D3.visible = true
	$CharacterBody2D/AnimationPlayer.play("hit enemy")
	vel = 0

func _process(delta):
	if vel < 0:
		$CharacterBody2D/Area2D/Sprite2D2.offset.x = 10
		$CharacterBody2D/Area2D/Sprite2D2.flip_h = false
	elif vel > 0:
		$CharacterBody2D/Area2D/Sprite2D2.offset.x = -10
		$CharacterBody2D/Area2D/Sprite2D2.flip_h = true
	if $CharacterBody2D/Timer.time_left == 0:
		queue_free()
	$CharacterBody2D.velocity.x = vel * 70
	$CharacterBody2D.move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage_bala"):
		body.take_damage_bala(1)
		hit_enemy()


func _on_area_2d_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage()
	if area.has_method("take_damage_bala"):
		hit_enemy()


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	$CharacterBody2D/Area2D/Sprite2D.visible = false
	$CharacterBody2D/Area2D/Sprite2D2.visible = true
	$CharacterBody2D/AnimationPlayer.play("hit_wall")
	vel = 0
	if randi_range(1,2) == 1:
		$CharacterBody2D/Area2D/AudioStreamPlayer2D.play()
	else:
		$CharacterBody2D/Area2D/AudioStreamPlayer2D2.play()
