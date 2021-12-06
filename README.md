# Escoria Ink Bridge

![Escoria Ink Bridge logo](icon.png)

This addon for [Godot](https://godotengine.org) adds support for playing
[Ink](https://www.inklestudios.com/ink/) scripts in 
[Escoria](https://github.com/godot-escoria) adventure game framework.

Ink was created by [Inkle Studios](https://www.inklestudios.com). This addon
is not affiliated with Inkle Studios at all.

Please use the [deep entertainment issue tracker](https://github.com/deep-entertainment/issues/issues)
if you encounter any problems or require features.

This addon uses and bundles [inkgd](https://github.com/ephread/inkgd), which
is a pure GDScript implementation of ink.

## Installation

Install the addon using the Godot asset library and activate it in the
project settings afterwards.

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
- Each line of text has at least one 
  [tag](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#tags) 
  for the [translation/voice key](https://docs.escoria-framework.org/translation)
- If a line of text starts with two arrows `>>`, the following is interpreted
  as an [ESC command](https://docs.escoria-framework.org/esc-reference)
  and run directly
- Ink [global variables](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md#1-global-variables) are synchronized with [Escoria's globals](https://docs.escoria-framework.org/globals).
