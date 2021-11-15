extends Node


# Emitted when the ink story has ended
signal story_ended


const REGEX_TEXT="(?<character>[a-z]+):\\s*(?<text>.+)"


var InkRuntime = load("res://addons/inkgd/runtime.gd")
var Story = load("res://addons/inkgd/runtime/story.gd")


var _current_story = null

var _regex_text: RegEx = null


func _ready() -> void:
	_regex_text = RegEx.new()
	_regex_text.compile(REGEX_TEXT)
	call_deferred("_initializeInk")
	

# Check wether an ink file is valid
#
# #### Parameters
# - ink_file: Path to the compiled ink file
# **Returns** Wether the file can be compiled into an Ink Story
func is_story_valid(ink_file: String) -> bool:
	return not _get_story(ink_file) == null


func run_story(ink_file: String):
	_current_story = _get_story(ink_file)
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
		if text_info:
			if escoria.object_manager.has(text_info.get_string("character")):
				escoria.dialog_player.say(
					text_info.get_string("character"), 
					"floating", 
					text_info.get_string("text")
				)
			else:
				escoria.logger.report_errors(
					"escoria_ink_bridge.gd:_continue_story",
					[
						"Character %s not found" % [ 
							text_info.get_string("character")
						]
					]
				)	
		else:
			escoria.logger.report_errors(
				"escoria_ink_bridge.gd:_continue_story",
				[
					"Text doesn't match the form <character name>:<text>: %s" \
					% [
						text
					]
				]
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


