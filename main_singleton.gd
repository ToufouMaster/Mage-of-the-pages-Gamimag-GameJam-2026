extends Node2D


var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
