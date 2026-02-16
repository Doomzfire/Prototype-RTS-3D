extends Node
class_name HealthComponent

signal health_changed(current: float, maximum: float)
signal died

@export var max_health := 100.0
var current_health := 100.0

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func apply_damage(amount: float) -> void:
	if current_health <= 0.0:
		return
	current_health = max(current_health - amount, 0.0)
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		died.emit()

func heal_full() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)
