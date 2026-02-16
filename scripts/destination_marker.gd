extends MeshInstance3D

@export var lifetime := 1.0

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * 0.3, lifetime)
	tween.parallel().tween_property(self, "transparency", 1.0, lifetime)
	await get_tree().create_timer(lifetime).timeout
	queue_free()
