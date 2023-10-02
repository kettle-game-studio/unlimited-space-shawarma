extends Control
class_name UIController

@export var textLabel: RichTextLabel
@export var dialog_box: RichTextLabel
@export var dialog_timeout: float = 10
@export var hunger_bar: ProgressBar

var name_color = Color(0, 1, 0)
var text_color = Color(1, 1, 1)

func _process(delta: float):
	for text in dialog_text:
		text.time -= delta
	var tmp: Array[DialogNode] = []
	for txt in dialog_text:
		if txt.time > 0:
			tmp.push_back(txt)
		else:
			print(txt.time)
	dialog_text = tmp
	build_text()

func is_npc_talking() -> bool:
	for text in dialog_text:
		if text.name != "You" && text.name != "Hint":
			return true
	return false

class DialogNode:
	var name: String
	var text: String
	var time: float
	var color
	
	func _init(name: String, text: String, time: float, color):
		self.name = name
		self.text = text
		self.time = time
		self.color = color

var dialog_text: Array[DialogNode] = []

func build_text():
	var res = ""
	for txt in dialog_text:
		var color = txt.color if txt.color else name_color
		var nme_color = Color(color, txt.time / dialog_timeout).to_html(true)
		var txt_color = Color(text_color, txt.time / dialog_timeout).to_html(true)
		res += "[center][color=%s][b]%s:[/b] [/color][color=%s]%s[/color][/center]" % [nme_color, txt.name, txt_color, txt.text]

	dialog_box.text = res

func add_dialog(name: String, text: String, color = null):
	var dialog = DialogNode.new(name, text, dialog_timeout, color)
	dialog_text.push_back(dialog)

func set_help_text(text: String) -> void:
	textLabel.text = "[center]%s[/center]" % text
