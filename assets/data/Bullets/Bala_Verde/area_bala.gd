extends Area2D

var player

var daño = 1

var vel = 450.0

@onready var Sprite_Bala_Verde = $Sprite_Bala_Verde
@onready var Sprite_Colision_Enemigo = $Sprite_Colision_Enemigo
@onready var Sprite_Colision_Pared = $Sprite_Colision_Pared
@onready var sfx_Colision_Pared1 = $sfx_Colision_Pared1
@onready var sfx_Colision_Pared2 = $sfx_Colision_Pared2

func hit_enemy():
    Sprite_Bala_Verde.visible = false
    Sprite_Colision_Enemigo.visible = true
    $Animaciones.play("hit enemy")
    vel = 0

func _process(delta):
    if vel < 0 and ( not Sprite_Colision_Pared.offset.x == 10) and Sprite_Colision_Pared.flip_h == true:
        Sprite_Colision_Pared.offset.x = 10
        Sprite_Colision_Pared.flip_h = false
    elif vel > 0 and ( not Sprite_Colision_Pared.offset.x == -10) and Sprite_Colision_Pared.flip_h == false:
        Sprite_Colision_Pared.offset.x = -10
        Sprite_Colision_Pared.flip_h = true
    if $Timer.time_left == 0:
        hit_enemy()
    position.x += vel * delta


func _on_area_entered(area):
    if area.has_method("take_damage"):
        area.take_damage()
    if area.has_method("take_damage_bala"):
        hit_enemy()


func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
    if not body.has_method("take_damage_bala"):
        Sprite_Bala_Verde.visible = false
        Sprite_Colision_Pared.visible = true
        $Animaciones.play("hit_wall")
        vel = 0
        if randi_range(1, 2) == 1:
            sfx_Colision_Pared1.play()
        else:
            sfx_Colision_Pared2.play()


func _on_body_entered(body):
    if body.has_method("take_damage_bala"):
        body.take_damage_bala(1)
        hit_enemy()
