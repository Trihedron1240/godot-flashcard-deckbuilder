extends Control
class_name CardUI

var card: Card
var player
var targets: Array = []

@onready var title_label: Label = $Panel/VBoxContainer/Title
@onready var preview_label: Label = $Panel/VBoxContainer/Preview
@onready var cost_label: Label = $Panel/VBoxContainer/Cost

func setup(c: Card, p, t: Array) -> void:
    card = c
    player = p
    targets = t
    title_label.text = card.title
    if card is QuestionCard:
        preview_label.text = card.question
    else:
        preview_label.text = ""
    cost_label.text = "Cost: %d" % card.cost

func _gui_input(event) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if player.energy < card.cost:
            return
        player.energy -= card.cost
        card.play(targets, player)
