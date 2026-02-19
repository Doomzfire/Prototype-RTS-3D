extends MeshInstance3D
class_name PooledMarker

@export var lifetime := 0.45
@export var start_scale := 0.55
@export var end_scale := 1.2

func play_once() -> void:
	visible = true
	scale = Vector3.ONE * start_scale
	transparency = 0.0
	if get_tree() == null:
		return
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * end_scale, lifetime)
	tween.parallel().tween_property(self, "transparency", 1.0, lifetime)
	tween.finished.connect(func() -> void:
		visible = false
	)
