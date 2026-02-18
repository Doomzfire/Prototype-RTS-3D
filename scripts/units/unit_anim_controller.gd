extends Node
class_name UnitAnimController

signal death_sequence_finished

const MOVE_EPS := 0.1

const IDLE_ANIMS: Array[StringName] = [&"Idle_01", &"Idle_02", &"Idle_03"]
const WALK_ANIM: StringName = &"Walk_01"
const ATTACK_ANIMS: Array[StringName] = [&"Attack_01", &"Attack_02", &"Attack_03"]
const DEATH_1_ANIM: StringName = &"Death_01"
const DEATH_2_ANIM: StringName = &"Death_02"

@export var animation_player_path: NodePath

var anim_player: AnimationPlayer

var _current_anim: StringName = &""
var _is_moving := false
var _is_attacking := false
var _is_dying := false

func _ready() -> void:
	_resolve_animation_player()
	if anim_player == null:
		push_warning("UnitAnimController: AnimationPlayer not found")
		return

	anim_player.animation_finished.connect(_on_animation_finished)
	_set_loop_mode_if_exists(WALK_ANIM, Animation.LOOP_LINEAR)
	for idle_anim in IDLE_ANIMS:
		_set_loop_mode_if_exists(idle_anim, Animation.LOOP_NONE)
	_play_random_idle()

func set_move_speed(speed: float) -> void:
	_is_moving = speed > MOVE_EPS
	if _is_dying or _is_attacking:
		return
	if _is_moving:
		_play_animation(WALK_ANIM)
	elif not _is_idle_animation(_current_anim):
		_play_random_idle()

func request_attack() -> void:
	if anim_player == null or _is_dying or _is_attacking:
		return

	var attack_anim := _pick_random_existing(ATTACK_ANIMS)
	if attack_anim == StringName(""):
		return

	_is_attacking = true
	_play_animation(attack_anim)

func request_death_sequence() -> void:
	if anim_player == null:
		death_sequence_finished.emit()
		return
	if _is_dying:
		return

	_is_dying = true
	_is_attacking = false
	if _has_animation(DEATH_1_ANIM):
		_play_animation(DEATH_1_ANIM)
	elif _has_animation(DEATH_2_ANIM):
		_play_animation(DEATH_2_ANIM)
	else:
		death_sequence_finished.emit()

func _resolve_animation_player() -> void:
	if animation_player_path != NodePath(""):
		anim_player = get_node_or_null(animation_player_path) as AnimationPlayer
	if anim_player == null:
		anim_player = find_child("AnimationPlayer", true, false) as AnimationPlayer

func _play_random_idle() -> void:
	if anim_player == null:
		return

	var options := _get_existing(IDLE_ANIMS)
	if options.is_empty():
		return

	var next_anim := options[randi() % options.size()]
	if options.size() > 1 and next_anim == _current_anim:
		next_anim = options[(options.find(next_anim) + 1) % options.size()]
	_play_animation(next_anim)

func _play_animation(anim_name: StringName) -> void:
	if anim_player == null or anim_name == StringName(""):
		return
	if _current_anim == anim_name and anim_player.is_playing():
		return
	if not _has_animation(anim_name):
		return
	anim_player.play(anim_name)
	_current_anim = anim_name

func _on_animation_finished(anim_name: StringName) -> void:
	if _is_dying:
		if anim_name == DEATH_1_ANIM and _has_animation(DEATH_2_ANIM):
			_play_animation(DEATH_2_ANIM)
			return
		if anim_name == DEATH_2_ANIM or (anim_name == DEATH_1_ANIM and not _has_animation(DEATH_2_ANIM)):
			death_sequence_finished.emit()
		return

	if _is_attacking and ATTACK_ANIMS.has(anim_name):
		_is_attacking = false
		if _is_moving:
			_play_animation(WALK_ANIM)
		else:
			_play_random_idle()
		return

	if not _is_moving and not _is_attacking and _is_idle_animation(anim_name):
		_play_random_idle()

func _is_idle_animation(anim_name: StringName) -> bool:
	return IDLE_ANIMS.has(anim_name)

func _has_animation(anim_name: StringName) -> bool:
	return anim_player != null and anim_player.has_animation(String(anim_name))

func _set_loop_mode_if_exists(anim_name: StringName, loop_mode: int) -> void:
	if anim_player == null or not _has_animation(anim_name):
		return
	var animation := anim_player.get_animation(String(anim_name))
	if animation != null:
		animation.loop_mode = loop_mode

func _get_existing(candidates: Array[StringName]) -> Array[StringName]:
	var result: Array[StringName] = []
	for candidate in candidates:
		if _has_animation(candidate):
			result.append(candidate)
	return result

func _pick_random_existing(candidates: Array[StringName]) -> StringName:
	var options := _get_existing(candidates)
	if options.is_empty():
		return StringName("")
	return options[randi() % options.size()]
