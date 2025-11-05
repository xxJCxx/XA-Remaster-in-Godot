extends Node2D

var origin

var velocidadx = 0.5
var velocidady = 0.5
var dirx = 2
var diry = 0.1
var death = false
var vida = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = position

func destroy():
	queue_free()
	
func destroy_area():
	$Area2D.queue_free()
	$Area2D2.queue_free()
	$Area2D3.queue_free()

func hurt_true():
	$Sprite2D2.visible = true
func hurt_false():
	$Sprite2D2.visible = false
func dead():
	$Sprite2D.visible = false
	$explosion.visible = true
	$Sprite2D2.visible = false
	$AnimationPlayer.play("explosion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += velocidady
	velocidady = lerpf(velocidady, diry, 0.02)
	if position.y >= origin.y + 10:
		diry = -0.5
	if position.y <= origin.y -10:
		diry = 0.5
	
	position.x += velocidadx
	velocidadx = lerpf(velocidadx, dirx, 0.02)
	if position.x >= origin.x + 20:
		dirx = -0.5
	if position.x <= origin.x -20:
		dirx = 0.5

		
	var player = get_tree().get_first_node_in_group("player")
	if vida <= 0:
		dead()
		

func _on_area_2d_area_entered(area):
	if area.has_method("jump"):
		area.jump()
		dead()
	elif area.has_method("hit_enemy"):
		vida -= 1
		$AudioStreamPlayer2D2.play()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("hurt")


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5)
		dead()
