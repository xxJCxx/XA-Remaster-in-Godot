extends CharacterBody2D

var monedas = 0
var porcentaje_monedas = 0
var direction
var mov = true
var puntos = 0
var doble_salto_activado = true
var doble_salto = false
var vidas = 3
var vida = 11
var dir = 1
var bullet
var disparo_en_el_aire = false

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var bala = preload("res://bala_verde.tscn")
var efecto = preload("res://efecto_salto_doble.tscn")
@onready var animationTree : AnimationTree = $AnimationTree
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func take_moneda():
	monedas += 1

func take_leche():
	vida += 4
	clamp(vida,0,11)

func mov_on():
	mov = true
func mov_off():
	mov = false

func desactivar_animaciones():
	animationTree.set("parameters/conditions/Activar_escudo",false)
	animationTree.set("parameters/conditions/caminando",false)
	animationTree.set("parameters/conditions/Disparando",false)
	animationTree.set("parameters/conditions/Disparar_agachado",false)
	animationTree.set("parameters/conditions/Disparar_caminando",false)
	animationTree.set("parameters/conditions/Disparar_en_el_aire",false)
	animationTree.set("parameters/conditions/idle",false)
	animationTree.set("parameters/conditions/Salto",false)

func actualizar_vida():
	if vida == 11:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 9
	elif vida == 10:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 8
	elif vida == 9:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 7
	elif vida == 8:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 6
	elif vida <= 7 and vida >= 6:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 5
	elif vida == 5:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 4
	elif vida == 4:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 3
	elif vida == 3:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 2
	elif vida <= 2:
		$Camera2D/HUD/CanvasLayer/barra_vida.frame = 1

func disparo():
	if $Timer3.time_left == 0 and mov == true:
		bullet = bala.instantiate()
		bullet.vel = bullet.vel * dir
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		$Timer3.start()
		$AudioStreamPlayer3.play()

func daño_shader_on():
	set("modulate",Color(100,0,0))
func daño_shader_off():
	set("modulate",Color(1,1,1))

func take_damage(daño):
	$AnimationPlayer2.play("daño")
	vida -= daño
	$Camera2D.applyshake()

func jump():
	doble_salto_activado = true
	velocity.y = JUMP_VELOCITY

func doble_jump():
	if doble_salto == true and doble_salto_activado == true:
		velocity.y = JUMP_VELOCITY
		$AudioStreamPlayer4.play()
		doble_salto_activado = false
		var efecto_doble_salto = efecto.instantiate()
		get_parent().add_child(efecto_doble_salto)
		efecto_doble_salto.global_position = global_position

func take_doble_salto():
	doble_salto = true
	$Camera2D/HUD/CanvasLayer/doble_salto.hide()
	$Camera2D/HUD/CanvasLayer/doble_salto_anim.show()
	$AnimationPlayer3.play("doble_salto_anim")

func añadir_puntos(nuevos_puntos):
	puntos += int(nuevos_puntos)
	if puntos >= 999999:
		puntos = 999999
	$Camera2D/HUD/CanvasLayer/puntos/Label.text = str(puntos)
	
func añadir_vidas(nuevas_vidas):
	vidas += int(nuevas_vidas)
	if vidas >= 99:
		vidas = 99
	if vidas > 9:
		$Camera2D/HUD/CanvasLayer/vidas/Label.text = str(vidas)
	else:
		$Camera2D/HUD/CanvasLayer/vidas/Label.text = "0" + str(vidas)

func _ready():
	$Camera2D/HUD/CanvasLayer/puntos/Label.text = str(puntos)
	if vidas > 9:
		$Camera2D/HUD/CanvasLayer/vidas/Label.text = str(vidas)
	else:
		$Camera2D/HUD/CanvasLayer/vidas/Label.text = "0" + str(vidas)

func _physics_process(delta):
	$Camera2D/HUD/CanvasLayer/monedas/Label.text = str(porcentaje_monedas)
	
	if mov == true:
		direction = Input.get_axis("ui_left", "ui_right")
	else:
		direction = 0
	
	while $Camera2D/HUD/CanvasLayer/puntos/Label.get_total_character_count() < 6:
		$Camera2D/HUD/CanvasLayer/puntos/Label.text = "0" + $Camera2D/HUD/CanvasLayer/puntos/Label.text

	actualizar_vida()
	
	$Camera2D/HUD/CanvasLayer/puntos.position.x = DisplayServer.window_get_size().x/3
	$Camera2D/HUD/CanvasLayer/monedas.position.x = DisplayServer.window_get_size().x/2.2
	$Camera2D/HUD/CanvasLayer/vacas.position.x = DisplayServer.window_get_size().x/1.75
	
	
	if velocity.x == 0 and Input.is_action_pressed("Abajo"):
		desactivar_animaciones()
		animationTree.set("parameters/conditions/Activar_escudo",true)
	else:
		animationTree.set("parameters/conditions/Activar_escudo",false)
	
	
	
	if Input.is_action_pressed("Disparo") and is_on_floor() and velocity.x == 0 and velocity.y == 0 and not Input.is_action_pressed("Abajo"):
		desactivar_animaciones()
		animationTree.set("parameters/conditions/Disparando",true)
		disparo()
	elif Input.is_action_pressed("Disparo") and Input.is_action_pressed("Abajo") and velocity.y == 0:
		desactivar_animaciones()
		animationTree.set("parameters/conditions/Disparar_agachado",true)
		disparo()
	elif is_on_floor() and direction and not velocity.x == 0 and Input.is_action_pressed("Disparo"):
		animationTree.set("parameters/conditions/Disparando",false)
		animationTree.set("parameters/conditions/Disparar_caminando",true)
		disparo()
	else:
		animationTree.set("parameters/conditions/Disparando",false)
	
	# Add the gravity.
	if not is_on_floor():
		desactivar_animaciones()
		animationTree.set("parameters/conditions/Salto",true)
		velocity.y += gravity * 2 * delta
		if Input.is_action_pressed("Disparo"):
			desactivar_animaciones()
			animationTree.set("parameters/conditions/Disparar_en_el_aire",true)
			disparo()
			disparo_en_el_aire = true
			
	if direction and is_on_floor() and not Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
		desactivar_animaciones()
		animationTree.set("parameters/conditions/caminando",true)
	elif direction and is_on_floor() and Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
		desactivar_animaciones()
		animationTree.set("parameters/conditions/Disparar_caminando",true)
		disparo()
	
	if direction and not Input.is_action_pressed("Abajo"):
		velocity.x = direction * SPEED
		dir = int(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor() and velocity.x == 0 and velocity.y == 0 and animationTree.get("parameters/conditions/Disparando") == false and  not Input.is_action_pressed("Disparo") and not Input.is_action_pressed("Abajo"):
		desactivar_animaciones()
		animationTree.set("parameters/conditions/idle",true)
	else:
		animationTree.set("parameters/conditions/idle",false)
	# Handle Jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor() and not animationTree.get("parameters/conditions/Activar_escudo") == true:
		if mov == true:
			audio_player.play()
			jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction == -1 and not Input.is_action_pressed("Abajo"):
		$SpriteHero.flip_h = true
	elif direction == 1 and not Input.is_action_pressed("Abajo"):
		$SpriteHero.flip_h = false
	elif not Input.is_action_pressed("Abajo"):
		$StaticBody2D/CollisionShape2D2.disabled = true
		$StaticBody2D/CollisionShape2D.disabled = true
	if Input.is_action_pressed("Abajo") and $SpriteHero.flip_h == true:
		$StaticBody2D/CollisionShape2D.disabled = true
		$StaticBody2D/CollisionShape2D2.disabled = false
	elif Input.is_action_pressed("Abajo") and $SpriteHero.flip_h == false:
		$StaticBody2D/CollisionShape2D.disabled = false
		$StaticBody2D/CollisionShape2D2.disabled = true
		
	if is_on_floor():
		doble_salto_activado = true
	elif Input.is_action_just_pressed("Salto"):
		doble_jump()

	move_and_slide()
