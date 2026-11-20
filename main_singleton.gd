extends Node2D


var player : Player

func _ready() -> void:
	player = get_tree().root.get_node("Node2D/WorldViewport/World/Player")
