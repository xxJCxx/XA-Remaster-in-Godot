extends Area2D

var dir = 0.2
var vel = 0.2
var origin

func _ready():
	origin = $"..".position


func _process(delta):
	vel = lerpf(vel, dir, 1 * delta)
	$"..".position.y += vel
	if $"..".position.y >= origin.y +5:
		dir = -0.2
	if $"..".position.y <= origin.y:
		dir = 0.2

func desabilitar():
	$CollisionShape2D.disabled = true

func _on_body_entered(body):
	
	if body.has_method("take_doble_salto"):
		body.take_doble_salto()
		$"../Sprite2D".visible = false
		$"../Sprite2D2".visible = true
		$"../AnimationPlayer".play("take_item")
		$"../AudioStreamPlayer2D".play()
