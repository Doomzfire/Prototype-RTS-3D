extends Node
class_name OrderFeedbackManager

@export var move_marker_scene: PackedScene
@export var attack_marker_scene: PackedScene
@export var pool_size := 8

var _move_pool: Array[Node3D] = []
var _attack_pool: Array[Node3D] = []
var _move_index := 0
var _attack_index := 0

func _ready() -> void:
	_move_pool = _build_pool(move_marker_scene)
	_attack_pool = _build_pool(attack_marker_scene)

func show_move_marker(position: Vector3) -> void:
	_show_marker(_move_pool, true, position)

func show_attack_marker(target: Node3D) -> void:
	if target == null:
		return
	_show_marker(_attack_pool, false, target.global_position)

func _build_pool(scene: PackedScene) -> Array[Node3D]:
	var pool: Array[Node3D] = []
	if scene == null:
		return pool
	for _i in pool_size:
		var marker := scene.instantiate() as Node3D
		if marker == null:
			continue
		marker.visible = false
		add_child(marker)
		pool.append(marker)
	return pool

func _show_marker(pool: Array[Node3D], is_move: bool, position: Vector3) -> void:
	if pool.is_empty():
		return
	var index := _move_index if is_move else _attack_index
	var marker := pool[index]
	if is_move:
		_move_index = (_move_index + 1) % pool.size()
	else:
		_attack_index = (_attack_index + 1) % pool.size()
	marker.global_position = position
	if marker.has_method("play_once"):
		marker.call("play_once")
	else:
		marker.visible = true
