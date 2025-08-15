extends Control
class_name QuestionUI

signal answered(was_correct: bool)

@onready var question_label: Label = $Panel/VBox/Question
@onready var choices_container: VBoxContainer = $Panel/VBox/Choices
@onready var explanation_label: Label = $Panel/VBox/Explanation
@onready var continue_button: Button = $Panel/VBox/Continue

var current_card: QuestionCard

func show_question(card: QuestionCard) -> void:
    current_card = card
    question_label.text = card.question
    explanation_label.text = card.explanation
    explanation_label.visible = false
    continue_button.disabled = true
    for c in choices_container.get_children():
        c.queue_free()
    for i in card.choices.size():
        var btn := Button.new()
        btn.text = card.choices[i]
        btn.pressed.connect(func(): _on_choice_selected(i))
        choices_container.add_child(btn)

func _on_choice_selected(index: int) -> void:
    var correct := index == current_card.correct_index
    explanation_label.visible = true
    continue_button.disabled = false
    continue_button.pressed.connect(func(): answered.emit(correct), CONNECT_ONESHOT)
