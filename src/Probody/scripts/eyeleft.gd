extends Node2D

onready var child = get_children()[0]

onready var max_dist = 14

#Função para que a o olho esquerdo da Celinha se movam nas telas em que ela aparece
func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	var dir = Vector2.ZERO.direction_to(mouse_pos)
	var dist = mouse_pos.length()
	child.position = dir * min(dist, max_dist)
