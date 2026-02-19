extends CharacterBody3D
class_name Unit

signal selected_changed(is_selected: bool)
signal defeated(unit: Unit)

@export var team := 0
@export var move_speed := 5.5
@export var stop_distance := 0.45
@export var attack_range := 4.0
@export var attack_damage := 10.0
@export var attack_cooldown := 0.8
@export var attack_windup_sec := 0.2
@export var stop_to_attack := true
@export var separation_distance := 0.9
@export var separation_strength := 2.4

@onready var selection_indicator: MeshInstance3D = $SelectionIndicator
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var health: HealthComponent = $HealthComponent
@onready var health_label: Label3D = $HealthLabel
@onready var visual_anim: Node = get_node_or_null("AnimController") if get_node_or_null("AnimController") != null else get_node_or_null("UnitVisualAnim")

var move_target := Vector3.ZERO
var has_move_target := false
var move_arrive_radius := -1.0

var attack_target: Unit
var attack_timer := 0.0
var attack_windup_timer := 0.0
var attack_in_progress := false
var selected := false
var is_dead := false

func _ready() -> void:
	add_to_group("units")
	if team == 0:
		add_to_group("player_units")
	else:
		add_to_group("enemy_units")
	selection_indicator.visible = false
	health.died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	attack_timer = max(attack_timer - delta, 0.0)
	if attack_in_progress:
		attack_windup_timer = max(attack_windup_timer - delta, 0.0)
		if attack_windup_timer <= 0.0:
			_finish_attack_hit()
			attack_in_progress = false

	if is_instance_valid(attack_target):
		var distance := global_position.distance_to(attack_target.global_position)
		if distance <= attack_range:
			if stop_to_attack:
				has_move_target = false
				velocity = Vector3.ZERO
			look_at(Vector3(attack_target.global_position.x, global_position.y, attack_target.global_position.z), Vector3.UP)
			if attack_timer <= 0.0 and not attack_in_progress:
				_start_attack_windup()
		elif not attack_in_progress:
			_set_move_target(attack_target.global_position, stop_distance)
	elif has_move_target:
		_move_towards_target()
	else:
		velocity = Vector3.ZERO

	velocity += _compute_separation(delta)
	move_and_slide()
	if visual_anim != null and visual_anim.has_method("set_move_speed"):
		visual_anim.call("set_move_speed", velocity.length())

func set_selected(value: bool) -> void:
	if is_dead:
		value = false
	selected = value
	selection_indicator.visible = value
	selected_changed.emit(value)

func issue_move(target: Vector3, arrive_radius: float = -1.0) -> void:
	if is_dead:
		return
	attack_target = null
	_set_move_target(target, arrive_radius)

func issue_attack(target_unit: Unit) -> void:
	if is_dead or target_unit == self:
		return
	attack_target = target_unit

func _set_move_target(target: Vector3, arrive_radius: float = -1.0) -> void:
	move_target = target
	has_move_target = true
	move_arrive_radius = arrive_radius

func _move_towards_target() -> void:
	var to_target := move_target - global_position
	to_target.y = 0.0
	var arrive_radius := stop_distance if move_arrive_radius <= 0.0 else move_arrive_radius
	if to_target.length() <= arrive_radius:
		has_move_target = false
		velocity = Vector3.ZERO
		return

	var dir := to_target.normalized()
	velocity = dir * move_speed
	look_at(Vector3(move_target.x, global_position.y, move_target.z), Vector3.UP)

func _start_attack_windup() -> void:
	attack_timer = attack_cooldown
	attack_in_progress = true
	attack_windup_timer = max(attack_windup_sec, 0.0)
	if visual_anim != null:
		if visual_anim.has_method("request_attack"):
			visual_anim.call("request_attack")
		elif visual_anim.has_method("trigger_attack"):
			visual_anim.call("trigger_attack")

func _finish_attack_hit() -> void:
	if not is_instance_valid(attack_target):
		return
	var distance := global_position.distance_to(attack_target.global_position)
	if distance > attack_range + 0.4:
		return
	attack_target.health.apply_damage(attack_damage)
	AudioManager.instance.play_sfx("attack_hit")

func _compute_separation(delta: float) -> Vector3:
	if separation_distance <= 0.0 or separation_strength <= 0.0:
		return Vector3.ZERO

	var repulse := Vector3.ZERO
	var group_name := "player_units" if team == 0 else "enemy_units"
	for node in get_tree().get_nodes_in_group(group_name):
		var other := node as Unit
		if other == null or other == self or other.is_dead:
			continue
		var offset := global_position - other.global_position
		offset.y = 0.0
		var dist := offset.length()
		if dist <= 0.001 or dist >= separation_distance:
			continue
		var strength := 1.0 - (dist / separation_distance)
		repulse += offset.normalized() * strength

	if repulse.length_squared() == 0.0:
		return Vector3.ZERO
	return repulse.normalized() * separation_strength * delta

func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	AudioManager.instance.play_sfx("death")
	defeated.emit(self)
	set_selected(false)
	remove_from_group("units")
	remove_from_group("player_units")
	remove_from_group("enemy_units")
	if collision_shape != null:
		collision_shape.disabled = true
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	attack_target = null
	has_move_target = false
	attack_in_progress = false
	velocity = Vector3.ZERO
	if visual_anim != null and visual_anim.has_method("request_death_sequence"):
		var started := bool(visual_anim.call("request_death_sequence"))
		if started and visual_anim.has_signal("death_finished"):
			set_physics_process(false)
			await visual_anim.death_finished
	queue_free()

func _on_health_changed(current: float, maximum: float) -> void:
	health_label.text = "%d/%d" % [int(current), int(maximum)]
