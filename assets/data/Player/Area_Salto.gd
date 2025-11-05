extends Area2D

@onready var Player = $".."

func jump():
    Player.jump()
