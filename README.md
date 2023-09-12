# Escoria Ink Bridge

![Escoria Ink Bridge logo](icon.png)

This addon for [Godot](https://godotengine.org) adds support for playing
[Ink](https://www.inklestudios.com/ink/) scripts in 
[Escoria](https://github.com/godot-escoria) adventure game framework.

Ink was created by [Inkle Studios](https://www.inklestudios.com). This addon
is not affiliated with Inkle Studios at all.

Please use the [deep entertainment issue tracker](https://github.com/deep-entertainment/issues/issues)
if you encounter any problems or require features.

# Requirements

* [Godot 3.5](https://godotengine.org/)
* [inkgd 0.5.0](https://github.com/ephread/inkgd)
* [ink 1.1.1](https://github.com/inkle/ink)
* [escoria-core](http://github.com/godot-escoria/escoria-core.git), Escoria 4.0.0a
* Any [UI](https://github.com/godot-escoria/escoria-ui-simplemouse/) and [dialog manager](https://github.com/godot-escoria/escoria-dialog-simple) for Escoria (testing using the defaults)

## Installation

Download a zip of the repo and copy the plugin (from the addons folder) into a Godot project. The sample project can be used for testing.

## Using

The addon expects that ink scripts, which are compiled with
inklecate or [inky](https://github.com/inkle/inky) to JSON files are located
in the project directory.

To start an ink script from Escoria, use the following ESC command:

    play_ink res://path/to/ink_script.ink.json

This will play the specified compiled ink script using the configured
[Escoria dialog manager](https://docs.escoria-framework.org/dialog-manager).

## Conventions

The addon uses the following conventions:

- Each line of text starts with the global id of the speaking characters,
  followed by a `:` before the actual text starts
- The first [tag](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#tags) 
  in each line of text will be used for the [translation/voice key](https://docs.escoria-framework.org/translation)
- If a line of text starts with two arrows `>>`, the following is interpreted
  as an [ESC command](https://docs.escoria-framework.org/esc-reference)
  and run directly
- Ink [global variables](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#1-global-variables) are synchronized with [Escoria's globals](https://docs.escoria-framework.org/globals).

## Contributing

Clone the repo. Make sure changes work in the test scenes.