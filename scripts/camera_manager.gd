extends Node3D
class_name CameraManager

@export var move_speed := 26.0
@export var edge_pan_enabled := true
@export var edge_pan_margin := 16.0
@export var edge_pan_speed_multiplier := 1.0
@export var zoom_speed := 2.0
@export var smoothness := 8.0
@export var min_zoom := 6.0
@export var max_zoom := 55.0
@export var allow_rotation := true
@export var rotation_speed := 1.6
@export var orbit_sensitivity := 0.008
@export var min_pitch_deg := -80.0
@export var max_pitch_deg := -10.0
@export var map_min := Vector2(-40, -40)
@export var map_max := Vector2(40, 40)
@export var focus_selection_manager_path: NodePath

@onready var yaw_node: Node3D = $Yaw
@onready var pitch_node: Node3D = $Yaw/Pitch
@onready var cam: Camera3D = $Yaw/Pitch/Camera3D
@onready var selection_manager: SelectionManager = get_node_or_null(focus_selection_manager_path)

var target_zoom := 30.0
var yaw := 0.0
var pitch := 0.0
var target_position := Vector3.ZERO

func _ready() -> void:
	yaw = yaw_node.rotation.y
	pitch = clampf(pitch_node.rotation.x, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))
	target_zoom = clamp(cam.position.z, min_zoom, max_zoom)
	target_position = position
	_apply_rotations(1.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom += zoom_speed

	if event is InputEventMouseMotion and Input.is_action_pressed("cam_orbit"):
		yaw -= event.relative.x * orbit_sensitivity
		pitch -= event.relative.y * orbit_sensitivity
		pitch = clampf(pitch, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F:
		_focus_on_selection()

	target_zoom = clamp(target_zoom, min_zoom, max_zoom)

func _process(delta: float) -> void:
	var input_vec := Vector2.ZERO
	input_vec.y += Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	input_vec.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if edge_pan_enabled:
		input_vec += _edge_pan_input() * edge_pan_speed_multiplier

	if input_vec.length() > 1.0:
		input_vec = input_vec.normalized()

	var yaw_basis := Basis(Vector3.UP, yaw)
	var forward := -yaw_basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right := yaw_basis.x
	right.y = 0.0
	right = right.normalized()

	var world_dir := (right * input_vec.x) + (forward * input_vec.y)
	if world_dir.length_squared() > 0.0:
		target_position += world_dir.normalized() * move_speed * delta

	if allow_rotation:
		yaw += (Input.get_action_strength("cam_rotate_right") - Input.get_action_strength("cam_rotate_left")) * rotation_speed * delta

	target_position.x = clamp(target_position.x, map_min.x, map_max.x)
	target_position.z = clamp(target_position.z, map_min.y, map_max.y)
	position = position.lerp(target_position, clampf(smoothness * delta, 0.0, 1.0))
	_apply_rotations(clampf(smoothness * delta, 0.0, 1.0))
	cam.position.z = lerpf(cam.position.z, target_zoom, clampf(smoothness * delta, 0.0, 1.0))

func _edge_pan_input() -> Vector2:
	var result := Vector2.ZERO
	var viewport_rect := get_viewport().get_visible_rect()
	var mouse_pos := get_viewport().get_mouse_position()

	if mouse_pos.x <= edge_pan_margin:
		result.x -= 1.0
	elif mouse_pos.x >= viewport_rect.size.x - edge_pan_margin:
		result.x += 1.0

	if mouse_pos.y <= edge_pan_margin:
		result.y -= 1.0
	elif mouse_pos.y >= viewport_rect.size.y - edge_pan_margin:
		result.y += 1.0

	return result

func _apply_rotations(weight: float) -> void:
	yaw_node.rotation.y = lerp_angle(yaw_node.rotation.y, yaw, weight)
	pitch_node.rotation.x = lerp_angle(pitch_node.rotation.x, pitch, weight)
	yaw_node.transform.basis = yaw_node.transform.basis.orthonormalized()
	pitch_node.transform.basis = pitch_node.transform.basis.orthonormalized()

func _focus_on_selection() -> void:
	if selection_manager == null:
		return
	var selected_units := selection_manager.get_selected_units()
	if selected_units.is_empty():
		return

	var center := Vector3.ZERO
	var count := 0
	for unit in selected_units:
		if is_instance_valid(unit):
			center += unit.global_position
			count += 1
	if count == 0:
		return
	target_position = center / count
	target_position.x = clamp(target_position.x, map_min.x, map_max.x)
	target_position.z = clamp(target_position.z, map_min.y, map_max.y)
