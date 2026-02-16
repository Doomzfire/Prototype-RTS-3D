extends Node
class_name OrderManager

@export var camera_path: NodePath
@export var selection_manager_path: NodePath
@export var marker_scene: PackedScene

@onready var camera: Camera3D = get_node(camera_path)
@onready var selection_manager: SelectionManager = get_node(selection_manager_path)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_handle_right_click(event.position)

func _handle_right_click(mouse_pos: Vector2) -> void:
	var units := selection_manager.get_selected_units()
	if units.is_empty():
		return

	var hit := _raycast(mouse_pos)
	if hit.is_empty():
		return

	var collider = hit.get("collider")
	if collider is Unit and collider.team != 0:
		for unit in units:
			if is_instance_valid(unit):
				unit.issue_attack(collider)
		AudioManager.instance.play_sfx("order")
		return

	var destination: Vector3 = hit["position"]
	_issue_group_move(units, destination)
	_spawn_marker(destination)
	AudioManager.instance.play_sfx("order")

func _issue_group_move(units: Array[Unit], destination: Vector3) -> void:
	var cols := int(ceil(sqrt(units.size())))
	var spacing := 1.8
	for i in units.size():
		var row := i / cols
		var col := i % cols
		var offset := Vector3((col - (cols - 1) * 0.5) * spacing, 0.0, row * spacing)
		if is_instance_valid(units[i]):
			units[i].issue_move(destination + offset)

func _spawn_marker(pos: Vector3) -> void:
	if marker_scene == null:
		return
	var marker := marker_scene.instantiate()
	get_tree().current_scene.add_child(marker)
	marker.global_position = pos

func _raycast(mouse_pos: Vector2) -> Dictionary:
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * 500.0
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	var space_state := get_viewport().get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)
	return result
