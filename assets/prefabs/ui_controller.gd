extends Control
class_name UIController

@export var textLabel: RichTextLabel

func set_help_text(text: String) -> void:
	textLabel.text = "[center]%s[/center]" % text
