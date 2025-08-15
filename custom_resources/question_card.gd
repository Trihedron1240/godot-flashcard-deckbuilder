extends Card
class_name QuestionCard

@export var question: String = ""
@export var choices: PackedStringArray = PackedStringArray()
@export var correct_index: int = 0
@export_multiline var explanation: String = ""
@export_range(1,3,1) var difficulty: int = 1

var streak: int = 0
var ease: float = 2.5
var due_day: int = 0

func play(targets: Array, char_stats: Node) -> void:
    Events.request_question.emit(self, targets, char_stats)
