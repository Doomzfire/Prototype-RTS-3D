extends Node
class_name OrderManager

enum FormationMode {
	GRID,
	LINE
}

@export var camera_path: NodePath
@export var selection_manager_path: NodePath
@export var marker_scene: PackedScene
@export var feedback_manager_path: NodePath
@export var formation_mode := FormationMode.GRID
@export var formation_spacing := 1.8
@export var formation_line_width := 6
@export var arrive_radius := 0.55

@onready var camera: Camera3D = get_node(camera_path)
@onready var selection_manager: SelectionManager = get_node(selection_manager_path)
@onready var feedback_manager: OrderFeedbackManager = get_node_or_null(feedback_manager_path)

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
		if feedback_manager != null:
			feedback_manager.show_attack_marker(collider)
		AudioManager.instance.play_sfx("order")
		return

	var destination: Vector3 = hit["position"]
	_issue_group_move(units, destination)
	if feedback_manager != null:
		feedback_manager.show_move_marker(destination)
	else:
		_spawn_marker(destination)
	AudioManager.instance.play_sfx("order")

func _issue_group_move(units: Array[Unit], destination: Vector3) -> void:
	var valid_units: Array[Unit] = []
	for unit in units:
		if is_instance_valid(unit):
			valid_units.append(unit)
	valid_units.sort_custom(func(a: Unit, b: Unit) -> bool:
		return a.get_instance_id() < b.get_instance_id()
	)

	if valid_units.is_empty():
		return

	var right := camera.global_basis.x
	right.y = 0.0
	right = right.normalized()
	var forward := -camera.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()

	for i in valid_units.size():
		var offset2 := _offset_for_index(i, valid_units.size())
		var offset_world := (right * offset2.x) + (forward * offset2.y)
		valid_units[i].issue_move(destination + offset_world, arrive_radius)

func _offset_for_index(index: int, count: int) -> Vector2:
	if formation_mode == FormationMode.LINE:
		var width := max(formation_line_width, 1)
		var row := floori(float(index) / float(width))
		var col := index % width
		return Vector2((col - (width - 1) * 0.5) * formation_spacing, row * formation_spacing)

	var cols := int(ceil(sqrt(float(count))))
	var row_g := floori(float(index) / float(cols))
	var col_g := index % cols
	return Vector2((col_g - (cols - 1) * 0.5) * formation_spacing, row_g * formation_spacing)

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
