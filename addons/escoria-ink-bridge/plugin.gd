tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton(
		"EscoriaInkBridge",
		"res://addons/escoria-ink-bridge/api/escoria_ink_bridge.gd"
	)
	call_deferred("_register")


func _exit_tree() -> void:
	var command_directories: Array = ProjectSettings.get(
		"escoria/main/command_directories"
	)
	command_directories.erase("res://addons/escoria-ink-bridge/commands")
	ProjectSettings.set(
		"escoria/main/command_directories",
		command_directories
	)
	remove_autoload_singleton("EscoriaInkBridge")


# Register plugin with Escoria
func _register() -> void:
	var command_directories: Array = ProjectSettings.get(
		"escoria/main/command_directories"
	)
	
	command_directories.push_back("res://addons/escoria-ink-bridge/commands")
	ProjectSettings.set(
		"escoria/main/command_directories",
		command_directories
	)
