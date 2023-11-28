extends Node


# Emitted when the ink story has ended
signal story_ended


const REGEX_TEXT="(?<character>[a-z]+):\\s*(?<text>.+)"
const REGEX_COMMAND=">>\\s*(?<command>.+)"


var InkRuntime = load("res://addons/inkgd/runtime.gd")
var Story = load("res://addons/inkgd/runtime/story.gd")


var _current_story = null

var _regex_text: RegEx = RegEx.new()
var _regex_command: RegEx = RegEx.new()

func _ready() -> void:
	_regex_text.compile(REGEX_TEXT)
	_regex_command.compile(REGEX_COMMAND)
	call_deferred("_initializeInk")
	

# Check wether an ink file is valid
#
# #### Parameters
# - ink_file: Path to the compiled ink file
# **Returns** Wether the file can be compiled into an Ink Story
func is_story_valid(ink_file: String) -> bool:
	return not _get_story(ink_file) == null


func run_story(ink_file: String, knot := ""):
	_current_story = _get_story(ink_file)
	
	for variable in _current_story.variables_state.enumerate():
		if not escoria.globals_manager.has(variable):
			escoria.logger.error(
				self,
				"Ink variable %s not found in the Escoria globals." % variable
			)
		_current_story.observe_variable(variable, self, "_observe_variable")
		_current_story.variables_state.set(
			variable,
			escoria.globals_manager.get_global(variable)
		)
		
	_current_story.bind_external_function("runEsc", self, "_run_esc")

	# Jump to the given knot
	if knot != "":
		_current_story.choose_path_string(knot)
		
	_continue_story()


# Instantiate an Ink Story from a compile Ink file
#
# #### Parameters
# - ink_file: Path to the compiled ink file
# **Returns** The compiled story
func _get_story(ink_file: String):
	var ink_story = File.new()
	ink_story.open(ink_file, File.READ)
	var content = ink_story.get_as_text()
	ink_story.close()
	return Story.new(content)


# Initialize the ink runtime
func _initializeInk():
	InkRuntime.init(get_tree().root)


func _continue_story():
	if _current_story.can_continue:
		var text = _current_story.continue()
		var text_info = _regex_text.search(text)
		var command_info = _regex_command.search(text)
		if command_info:
			_run_esc(command_info.get_string("command"))
		elif text_info:
			# Set a dummy translation key if no translation tag is set
			var translation_key = "default" if _current_story.current_tags.size() == 0 else _current_story.current_tags[0]

			if escoria.object_manager.has(text_info.get_string("character")):
				escoria.dialog_player.say(
					text_info.get_string("character"), 
					"floating", 
					'%s:"%s"' % [
						translation_key,
						text_info.get_string("text")
					]
				)
			else:
				escoria.logger.error(
					self,
					"Character %s not found" % 
							text_info.get_string("character")		
				)				
		else:
			escoria.logger.error(
				self,
				"Text doesn't match the form <character name>:<text>: %s" \
				% text
			)
		yield(escoria.dialog_player, "say_finished")
		_continue_story()
	elif _current_story.current_choices.size() > 0:
		var dialog = ESCDialog.new()
		for choice in _current_story.current_choices:
			var option = ESCDialogOption.new()
			option.option = choice.text
			dialog.options.append(option)
		escoria.dialog_player.start_dialog_choices(dialog)
		var chosen_option = yield(escoria.dialog_player,"option_chosen")
		var i := 0
		for choice in _current_story.current_choices:
			if choice.text == chosen_option.option:
				_current_story.choose_choice_index(i)
			i += 1
		_continue_story()
	else:
		emit_signal("story_ended")


# Update Escoria's globals whenever a variable in ink is changed
#
# #### Parameters
# - variable_name: Name of the variable
# - value: The new value
func _observe_variable(variable_name: String, value):
	escoria.globals_manager.set_global(variable_name, value)


func _run_esc(command: String):
	var event = escoria.esc_compiler.compile([
		":run",
		command
	])
	escoria.event_manager.queue_background_event(
		"_ink",
		event.events["run"]
	)
	var event_return = yield(escoria.event_manager, "background_event_finished")
	
	while event_return[2] != "_ink" and event_return[1] != "run":
		event_return = yield(
			escoria.event_manager, 
			"background_event_finished"
		)
	
	if event_return[0] != ESCExecution.RC_OK:
		escoria.logger.error(
			self,
			"Command failed to run: (%d )%s" % [
					event_return[0],
					command
				]
		)
	
	_continue_story()
