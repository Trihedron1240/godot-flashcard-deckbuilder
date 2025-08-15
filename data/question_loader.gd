extends Node
class_name QuestionLoader

func load_from_json(path: String) -> Array[QuestionCard]:
    var cards: Array[QuestionCard] = []
    var file := FileAccess.open(path, FileAccess.READ)
    if file:
        var text := file.get_as_text()
        var data := JSON.parse_string(text)
        if data is Array:
            for item in data:
                var card := QuestionCard.new()
                card.id = item.get("id", "")
                card.title = item.get("question", "")
                card.question = item.get("question", "")
                card.choices = PackedStringArray(item.get("choices", []))
                card.correct_index = item.get("answer_index", 0)
                card.explanation = item.get("explanation", "")
                card.tags = PackedStringArray(item.get("tags", []))
                card.difficulty = int(item.get("difficulty", 1))
                cards.append(card)
    return cards
