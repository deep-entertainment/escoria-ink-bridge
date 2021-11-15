# `play_ink res://path/to/compiled-ink-file.json`
#
# Plays a compiled ink files in Escoria
#
# @ESC
extends ESCBaseCommand
class_name PlayInkCommand


func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		1,
		[TYPE_STRING],
		[null]
	)
	

func validate(arguments: Array):
	var dir = Directory.new()
	if not dir.file_exists(arguments[0]):
		escoria.logger.report_errors(
			"play_ink: invalid ink file",
			[
				"Ink file %s not found" % arguments[0]
			]
		)
		return false
	elif not EscoriaInkBridge.is_story_valid(arguments[0]):
		escoria.logger.report_errors(
			"play_ink: invalid ink file",
			[
				"Ink file %s could not be loaded" % arguments[0]
			]
		)
	return .validate(arguments)


func run(arguments: Array) -> int:
	EscoriaInkBridge.run_story(arguments[0])
	yield(EscoriaInkBridge, "story_ended")
	return ESCExecution.RC_OK


