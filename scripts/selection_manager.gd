extends Node
class_name SelectionManager

signal selection_changed(units: Array[Unit])

@export var camera_path: NodePath
@export var selection_box_path: NodePath

var selected_units: Array[Unit] = []
var drag_start := Vector2.ZERO
var dragging := false

@onready var camera: Camera3D = get_node(camera_path)
@onready var selection_box: ColorRect = get_node(selection_box_path)

func _ready() -> void:
	selection_box.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag_start = event.position
			dragging = true
			selection_box.visible = true
			selection_box.position = drag_start
			selection_box.size = Vector2.ZERO
		else:
			if dragging:
				_finalize_selection(event.position)
			dragging = false
			selection_box.visible = false
	elif event is InputEventMouseMotion and dragging:
		_update_drag_box(event.position)

func _update_drag_box(current_pos: Vector2) -> void:
	var top_left := Vector2(min(drag_start.x, current_pos.x), min(drag_start.y, current_pos.y))
	var bottom_right := Vector2(max(drag_start.x, current_pos.x), max(drag_start.y, current_pos.y))
	selection_box.position = top_left
	selection_box.size = bottom_right - top_left

func _finalize_selection(release_pos: Vector2) -> void:
	var shift := Input.is_key_pressed(KEY_SHIFT)
	if drag_start.distance_to(release_pos) < 6.0:
		_select_single(release_pos, shift)
	else:
		_select_box(shift)

func _select_single(mouse_pos: Vector2, additive: bool) -> void:
	var picked := _pick_unit(mouse_pos)
	if not additive:
		_clear_selection()
	if picked == null:
		_emit_change()
		return
	if additive and picked in selected_units:
		_remove_unit(picked)
	else:
		_add_unit(picked)
	AudioManager.instance.play_sfx("select")
	_emit_change()

func _select_box(additive: bool) -> void:
	if not additive:
		_clear_selection()

	var rect := Rect2(selection_box.position, selection_box.size)
	for node in get_tree().get_nodes_in_group("player_units"):
		var unit := node as Unit
		if unit == null:
			continue
		var screen_pos := camera.unproject_position(unit.global_position)
		if rect.has_point(screen_pos) and unit not in selected_units:
			_add_unit(unit)

	if selected_units.size() > 0:
		AudioManager.instance.play_sfx("select")
	_emit_change()

func _pick_unit(mouse_pos: Vector2) -> Unit:
	var origin := camera.project_ray_origin(mouse_pos)
	var end := origin + camera.project_ray_normal(mouse_pos) * 500.0
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	var space_state := get_viewport().get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return null
	var collider = result.get("collider")
	if collider is Unit and collider.is_in_group("player_units"):
		return collider
	return null

func get_selected_units() -> Array[Unit]:
	return selected_units

func _add_unit(unit: Unit) -> void:
	if unit not in selected_units:
		selected_units.append(unit)
		unit.set_selected(true)

func _remove_unit(unit: Unit) -> void:
	selected_units.erase(unit)
	unit.set_selected(false)

func _clear_selection() -> void:
	for unit in selected_units:
		if is_instance_valid(unit):
			unit.set_selected(false)
	selected_units.clear()

func _emit_change() -> void:
	selection_changed.emit(selected_units)
