extends Node
class_name CombatSystem

signal battle_finished(player_won: bool)

var finished := false

func _process(_delta: float) -> void:
	if finished:
		return
	var player_units := _alive_units("player_units")
	var enemy_units := _alive_units("enemy_units")
	if player_units == 0:
		finished = true
		battle_finished.emit(false)
	elif enemy_units == 0:
		finished = true
		battle_finished.emit(true)

func _alive_units(group_name: String) -> int:
	var count := 0
	for node in get_tree().get_nodes_in_group(group_name):
		if node is Unit and is_instance_valid(node):
			count += 1
	return count
