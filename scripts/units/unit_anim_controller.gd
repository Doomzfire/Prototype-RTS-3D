extends Node
class_name UnitAnimController

const MOVE_EPS: float = 0.1

@export var animation_player_path: NodePath

var anim_player: AnimationPlayer

var _idle_anims: Array[StringName] = [&"Idle_01", &"Idle_02", &"Idle_03"]
var _walk_anim: StringName = &"Walk_01"
var _attack_anims: Array[StringName] = [&"Attack_01", &"Attack_02", &"Attack_03"]
var _death_anims: Array[StringName] = [&"Death_01", &"Death_02"]

var _is_walking := false
var _is_attacking := false
var _is_dying := false
var _pending_death_stage := 0
var _warned_missing_anim_player := false

signal death_finished

func _ready() -> void:
	anim_player = _resolve_anim_player()
	if anim_player == null:
		if not _warned_missing_anim_player:
			push_warning("UnitAnimController: AnimationPlayer not found")
			_warned_missing_anim_player = true
		return

	anim_player.animation_finished.connect(_on_animation_finished)
	_configure_animation_loops()
	_play_idle_random()

func set_move_speed(speed: float) -> void:
	if _is_attacking or _is_dying or anim_player == null:
		return

	var should_walk := speed > MOVE_EPS
	if should_walk == _is_walking:
		return

	_is_walking = should_walk
	if _is_walking:
		_play_if_needed(_walk_anim)
	else:
		_play_idle_random()


func request_attack() -> bool:
	return trigger_attack()

func trigger_attack() -> bool:
	if anim_player == null or _is_dying:
		return false
	if _attack_anims.is_empty():
		return false

	_is_attacking = true
	_play_if_needed(_pick_random_existing(_attack_anims))
	return true

func trigger_death() -> bool:
	if anim_player == null:
		death_finished.emit()
		return false
	if _is_dying:
		return true

	_is_dying = true
	_is_attacking = false
	_is_walking = false
	_pending_death_stage = 1
	_play_if_needed(_death_anims[0])
	return true

func _resolve_anim_player() -> AnimationPlayer:
	if animation_player_path != NodePath(""):
		var explicit_player := get_node_or_null(animation_player_path) as AnimationPlayer
		if explicit_player != null:
			return explicit_player

	var root := owner if owner != null else get_parent()
	if root == null:
		return null

	var players := root.find_children("*", "AnimationPlayer", true, false)
	if players.is_empty():
		return null

	for p in players:
		var player := p as AnimationPlayer
		if player != null and player.has_animation("Idle_01") and player.has_animation("Walk_01"):
			return player

	return players[0] as AnimationPlayer

func _on_animation_finished(anim_name: StringName) -> void:
	if _is_dying:
		if _pending_death_stage == 1 and anim_name == _death_anims[0] and anim_player.has_animation(String(_death_anims[1])):
			_pending_death_stage = 2
			_play_if_needed(_death_anims[1])
			return
		if _pending_death_stage >= 1 and anim_name == _death_anims[min(_pending_death_stage, _death_anims.size() - 1)]:
			death_finished.emit()
		return

	if _is_attacking:
		if _attack_anims.has(anim_name):
			_is_attacking = false
			if _is_walking:
				_play_if_needed(_walk_anim)
			else:
				_play_idle_random()
		return

	if not _is_walking and _idle_anims.has(anim_name):
		_play_idle_random()

func _play_idle_random() -> void:
	if anim_player == null or _is_attacking or _is_dying:
		return

	var idle_choice := _pick_random_existing(_idle_anims)
	_play_if_needed(idle_choice)

func _pick_random_existing(candidates: Array[StringName]) -> StringName:
	if anim_player == null:
		return StringName("")

	var available: Array[StringName] = []
	for anim_name in candidates:
		if anim_player.has_animation(String(anim_name)):
			available.append(anim_name)

	if available.is_empty():
		return StringName("")
	if available.size() == 1:
		return available[0]

	return available[randi() % available.size()]

func _play_if_needed(anim_name: StringName) -> void:
	if anim_player == null or anim_name == StringName(""):
		return
	if anim_player.current_animation == anim_name and anim_player.is_playing():
		return
	anim_player.play(anim_name)

func _configure_animation_loops() -> void:
	_set_loop_mode(_walk_anim, Animation.LoopMode.LOOP_LINEAR)
	for anim_name in _idle_anims:
		_set_loop_mode(anim_name, Animation.LoopMode.LOOP_NONE)
	for anim_name in _attack_anims:
		_set_loop_mode(anim_name, Animation.LoopMode.LOOP_NONE)
	for anim_name in _death_anims:
		_set_loop_mode(anim_name, Animation.LoopMode.LOOP_NONE)

func _set_loop_mode(anim_name: StringName, mode: Animation.LoopMode) -> void:
	if anim_player == null or not anim_player.has_animation(String(anim_name)):
		return
	var anim := anim_player.get_animation(String(anim_name))
	if anim != null:
		anim.loop_mode = mode
