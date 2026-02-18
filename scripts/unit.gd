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

@onready var selection_indicator: MeshInstance3D = $SelectionIndicator
@onready var health: HealthComponent = $HealthComponent
@onready var health_label: Label3D = $HealthLabel
@onready var anim_controller: UnitAnimController = get_node_or_null("AnimController") as UnitAnimController

var move_target := Vector3.ZERO
var has_move_target := false
var attack_target: Unit
var attack_timer := 0.0
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
	if anim_controller != null:
		anim_controller.death_sequence_finished.connect(_on_death_sequence_finished)

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	attack_timer = max(attack_timer - delta, 0.0)
	if is_instance_valid(attack_target):
		var distance := global_position.distance_to(attack_target.global_position)
		if distance <= attack_range:
			velocity = Vector3.ZERO
			look_at(Vector3(attack_target.global_position.x, global_position.y, attack_target.global_position.z), Vector3.UP)
			if attack_timer <= 0.0:
				attack_timer = attack_cooldown
				if anim_controller != null:
					anim_controller.request_attack()
				attack_target.health.apply_damage(attack_damage)
				AudioManager.instance.play_sfx("attack_hit")
		else:
			_set_move_target(attack_target.global_position)
	elif has_move_target:
		var to_target := move_target - global_position
		to_target.y = 0.0
		if to_target.length() <= stop_distance:
			has_move_target = false
			velocity = Vector3.ZERO
		else:
			var dir := to_target.normalized()
			velocity = dir * move_speed
			look_at(Vector3(move_target.x, global_position.y, move_target.z), Vector3.UP)
	else:
		velocity = Vector3.ZERO

	move_and_slide()
	if anim_controller != null:
		anim_controller.set_move_speed(velocity.length())

func set_selected(value: bool) -> void:
	selected = value
	selection_indicator.visible = value
	selected_changed.emit(value)

func issue_move(target: Vector3) -> void:
	if is_dead:
		return
	attack_target = null
	_set_move_target(target)

func issue_attack(target_unit: Unit) -> void:
	if is_dead or target_unit == self:
		return
	attack_target = target_unit

func _set_move_target(target: Vector3) -> void:
	move_target = target
	has_move_target = true

func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	AudioManager.instance.play_sfx("death")
	attack_target = null
	has_move_target = false
	velocity = Vector3.ZERO
	selection_indicator.visible = false
	selected = false
	if anim_controller != null:
		anim_controller.request_death_sequence()
	else:
		_on_death_sequence_finished()

func _on_death_sequence_finished() -> void:
	defeated.emit(self)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	var collision_shape := get_node_or_null("CollisionShape3D") as CollisionShape3D
	if collision_shape != null:
		collision_shape.disabled = true
	queue_free()

func _on_health_changed(current: float, maximum: float) -> void:
	health_label.text = "%d/%d" % [int(current), int(maximum)]
