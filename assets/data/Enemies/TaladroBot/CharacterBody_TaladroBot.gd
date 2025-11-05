extends CharacterBody2D

var dir = 1
var mov = true
var death = false
var vida = 5
const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var RayCastDir = $RayCastDir
@onready var RayCastDir2 = $RayCastDir2
@onready var Efecto_Verde = $Efecto_Verde
@onready var Sprite_Muerte = $Sprite_Muerte
@onready var Animacion_Caminar = $Animacion_Caminar
@onready var Animacion_Daño = $"Animacion_Daño"
@onready var Sprite_TaladroBot = $Sprite_TaladroBot
@onready var Area_Daño = $"Area_Daño"
@onready var Sprite_Daño = $"Sprite_TaladroBot/Sprite_Daño"
@onready var sfx_Muerte = $sfx_Muerte
@onready var sfx_Daño = $"sfx_Daño"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func destroy():
    queue_free()

func destroy_collision():
    Area_Daño.queue_free()
    $CollisionShape2D.queue_free()

func hurt_true():
    Sprite_Daño.visible = true
func hurt_false():
    Sprite_Daño.visible = false
func dead():
    death = true
    Sprite_TaladroBot.visible = false
    Sprite_Muerte.visible = true
    Animacion_Daño.play("explosion")
    destroy_collision()
    mov = false

func _ready():
    Animacion_Caminar.play("Caminando")
    Efecto_Verde.play("Caminar")

func _physics_process(delta):
    if dir == 1:
        Sprite_TaladroBot.flip_h = false
        Sprite_Muerte.flip_h = false
        Sprite_Daño.flip_h = false
    else:
        Sprite_TaladroBot.flip_h = true
        Sprite_Muerte.flip_h = true
        Sprite_Daño.flip_h = true


    if death == true:
        dir = 0
    if not is_on_floor() and death == false:
        velocity.y += gravity * delta

    if RayCastDir.is_colliding() and not RayCastDir.get_collider().has_method("take_damage") and death == false:
        dir = - dir
        RayCastDir.target_position.x = - RayCastDir.target_position.x
        RayCastDir2.target_position.x = - RayCastDir2.target_position.x
    elif not RayCastDir2.is_colliding() and death == false:
        dir = - dir
        RayCastDir.target_position.x = - RayCastDir.target_position.x
        RayCastDir2.target_position.x = - RayCastDir2.target_position.x
    velocity.x = SPEED * dir
    move_and_slide()


func _on_area_daño_area_entered(area):
    if area.has_method("jump"):
        area.Player.añadir_puntos(5)
        area.jump()
        dead()
    elif area.has_method("hit_enemy"):
        vida -= 1
        sfx_Daño.play()
        Animacion_Daño.play("hurt")
        if vida <= 0:
            area.player.añadir_puntos(5)
            dead()


func _on_area_daño_body_entered(body):
    if body.has_method("take_damage"):
        body.take_damage(5)
        dead()
