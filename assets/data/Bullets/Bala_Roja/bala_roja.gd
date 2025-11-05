extends Area2D

var dirx = 0
var diry = 0
var daño = 1

var vel = 4

@onready var Sprite_Bala = $Sprite_Bala_roja
@onready var Sprite_Daño = $"Sprite_Daño"
@onready var Sprite_Colision_Pared = $Sprite_Colision_Pared
@onready var sfx_Colision_Pared = $sfx_Colision_Pared
@onready var sfx_Daño = $"sfx_Daño"

func hit_player():
    Sprite_Bala.visible = false
    Sprite_Colision_Pared.visible = true
    $Animaciones.play("hit enemy")
    vel = 0

func _ready() -> void :
    $"Sprite_Daño".visible = false
    $Sprite_Colision_Pared.visible = false

func _process(delta):
    if $RayCast_Arriba.is_colliding():
        vel = 0
        rotation_degrees = -90
        $Animaciones.play("hit_wall")
    elif $RayCast2D_Abajo.is_colliding():
        vel = 0
        rotation_degrees = 90
        $Animaciones.play("hit_wall")
    elif $RayCast2D_Izquierda.is_colliding():
        vel = 0
        rotation_degrees = -180
        $Animaciones.play("hit_wall")
    elif $RayCast_Arriba.is_colliding():
        vel = 0
        $Animaciones.play("hit_wall")
    elif dirx < 0:
        Sprite_Daño.offset.x = 10
        Sprite_Daño.flip_h = false
    elif dirx > 0:
        Sprite_Daño.offset.x = -10
        Sprite_Daño.flip_h = true
    elif $Timer.time_left == 0:
        hit_player()
    position.x += dirx * vel
    position.y += diry * vel

func _on_body_entered(body: Node2D) -> void :
    if body.has_method("take_damage"):
        body.take_damage(2)
        hit_player()
    elif body.has_method("block"):
        vel = 0
        Sprite_Bala.visible = false
        Sprite_Daño.visible = true
        if randi_range(1, 2) == 1:
            $sfx_block.play()
        else:
            $sfx_block2.play()
        $Animaciones.play("hit enemy")
    else:
        vel = 0
        Sprite_Bala.visible = false
        Sprite_Daño.visible = true
        $Animaciones.play("hit_wall")
        if randi_range(1, 2) == 1:
            sfx_Daño.play()
        else:
            sfx_Colision_Pared.play()
