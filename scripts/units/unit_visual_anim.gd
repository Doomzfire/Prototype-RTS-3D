extends Node
class_name UnitVisualAnim

const MOVE_EPS: float = 0.1

@export var visual_path: NodePath = ^"../Visual"
@export var idle_anim: StringName = &"Idle"
@export var walk_anim: StringName = &"Walk"

var anim_player: AnimationPlayer
var anim_tree: AnimationTree
var tree_playback: AnimationNodeStateMachinePlayback

var resolved_idle_anim: StringName = &""
var resolved_walk_anim: StringName = &""

var idle_state_name: StringName = &""
var walk_state_name: StringName = &""

var _is_walking := false

func _ready() -> void:
	var visual := get_node_or_null(visual_path)
	if visual == null:
		push_warning("UnitVisualAnim: Visual node not found at %s" % visual_path)
		return

	anim_player = visual.find_child("AnimationPlayer", true, false) as AnimationPlayer
	anim_tree = visual.find_child("AnimationTree", true, false) as AnimationTree

	if anim_player != null:
		resolved_idle_anim = _resolve_animation_name(idle_anim, "idle")
		resolved_walk_anim = _resolve_animation_name(walk_anim, "walk")

	if anim_tree != null:
		anim_tree.active = true
		tree_playback = anim_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		if tree_playback != null:
			idle_state_name = _resolve_state_name([StringName("Idle"), StringName("idle")], "idle")
			walk_state_name = _resolve_state_name([
				StringName("Walking"),
				StringName("Walk"),
				StringName("walking"),
				StringName("walk")
			], "walk")

	_play_idle()

func set_move_speed(speed: float) -> void:
	var should_walk := speed > MOVE_EPS
	if should_walk == _is_walking:
		return
	_is_walking = should_walk

	if _is_walking:
		_play_walk()
	else:
		_play_idle()

func _play_idle() -> void:
	if tree_playback != null and idle_state_name != StringName(""):
		tree_playback.travel(idle_state_name)
	elif anim_player != null and resolved_idle_anim != StringName("") and anim_player.current_animation != resolved_idle_anim:
		anim_player.play(resolved_idle_anim)

func _play_walk() -> void:
	if tree_playback != null and walk_state_name != StringName(""):
		tree_playback.travel(walk_state_name)
	elif anim_player != null and resolved_walk_anim != StringName("") and anim_player.current_animation != resolved_walk_anim:
		anim_player.play(resolved_walk_anim)

func _resolve_animation_name(preferred: StringName, fallback_contains: String) -> StringName:
	if anim_player == null:
		return StringName("")

	var preferred_name := String(preferred)
	if preferred_name != "" and anim_player.has_animation(preferred_name):
		return StringName(preferred_name)

	for anim_name: StringName in anim_player.get_animation_list():
		if String(anim_name).to_lower().contains(fallback_contains):
			return anim_name

	return StringName("")

func _resolve_state_name(candidates: Array[StringName], fallback_contains: String = "") -> StringName:
	if anim_tree == null:
		return StringName("")

	var tree_root := anim_tree.tree_root as AnimationNodeStateMachine
	if tree_root == null:
		return StringName("")

	for candidate in candidates:
		if tree_root.has_node(candidate):
			return candidate

	if fallback_contains != "":
		for state_name in tree_root.get_node_list():
			var lowered := String(state_name).to_lower()
			if lowered.contains(fallback_contains):
				return state_name

	return StringName("")
