extends Card
class_name QuestionCard
# Defines a multiple-choice question card used by the flashcard deck builder.

@export var question: String
@export var choices: PackedStringArray = PackedStringArray()
@export var correct_index: int = 0
@export_multiline var explanation: String
@export var tags: PackedStringArray = PackedStringArray()
@export_range(1,3,1) var difficulty: int = 1

func play(targets: Array, char_stats) -> void:
    Events.request_question.emit(self, targets, char_stats)
