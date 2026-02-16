extends CanvasLayer
class_name HUD

@export var selection_manager_path: NodePath
@export var combat_system_path: NodePath

@onready var selected_count_label: Label = $HUDPanel/SelectedCount
@onready var status_label: Label = $HUDPanel/Status
@onready var pause_menu: Panel = $PauseMenu

var paused := false

func _ready() -> void:
	pause_menu.visible = false
	var selection_manager: SelectionManager = get_node(selection_manager_path)
	selection_manager.selection_changed.connect(_on_selection_changed)
	var combat_system: CombatSystem = get_node(combat_system_path)
	combat_system.battle_finished.connect(_on_battle_finished)
	_on_selection_changed([])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		paused = not paused
		get_tree().paused = paused
		pause_menu.visible = paused
		status_label.text = "Paused" if paused else "Battle in progress"

func _on_selection_changed(units: Array[Unit]) -> void:
	selected_count_label.text = "Selected: %d" % units.size()

func _on_battle_finished(player_won: bool) -> void:
	status_label.text = "Victory!" if player_won else "Defeat"
