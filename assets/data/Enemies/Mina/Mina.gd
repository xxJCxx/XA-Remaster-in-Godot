extends Area2D

func take_damage_bala():
    pass

func _ready():
    pass



func _process(delta):
    pass


func _on_body_entered(body):
    if body.has_method("take_damage"):
        body.take_damage(11)
