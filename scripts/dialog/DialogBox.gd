extends Label

var head : Node
var t : float = 0
var choices : Array
var selection : int = 0

enum DialogState { PRINTING, WAITING, EMPTY }
var state : DialogState = DialogState.EMPTY

func attach_tree(node : Node):
	head = node
	choices = head.get_children()
	state = DialogState.PRINTING
	
func _input(event):
	if state == DialogState.WAITING:
		if head.get_child_count() > 0:
			if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
				selection = clamp( selection - 1, 0, head.get_child_count() ) 
				display_choices()
			elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
				selection = clamp( selection + 1, 0, head.get_child_count() ) 
				display_choices()

		if event.is_action_pressed("interact"):
			if head.get_child_count() > 0:
				if head.get_child(selection).jump_to:
					head = head.get_child(selection).jump_to
				else:
					head = head.get_child(selection).get_child(0)
			else:
				head = head.get_parent().get_child(head.get_index() + 1)
			
			t = 0
			if head == null:
				state = DialogState.EMPTY
				text = ""
			else: 
				choices = head.get_children()
				state = DialogState.PRINTING

func _process(delta: float) -> void:
	if state == DialogState.PRINTING:
		if t < head.message.length():
			t = min(head.message.length(),t+delta*head.speed)
			text = head.message.substr(0,int(t))
			if t == head.message.length():
				state = DialogState.WAITING
				selection = 0
				display_choices()
				
func display_choices():
	text = head.message
	for choice in choices:
		if selection == choice.get_index():
			text += "\n" + choice.choice_label + " []"
		else:
			text += "\n" + choice.choice_label
	
