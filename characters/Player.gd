extends Node
class_name Player

var deck: Array = []
var draw_pile: Array = []
var discard_pile: Array = []
var hand: Array = []
var energy: int = 3
var hp: int = 30

const HAND_LIMIT := 10

func build_starting_deck() -> void:
    var loader := preload("res://data/question_loader.gd").new()
    deck = loader.load_from_json("res://data/sample_questions.json")
    draw_pile = deck.duplicate()
    discard_pile.clear()
    hand.clear()
    energy = 3
    randomize()

func shuffle() -> void:
    var n := draw_pile.size()
    for i in range(n - 1, 0, -1):
        var j := randi() % (i + 1)
        var tmp = draw_pile[i]
        draw_pile[i] = draw_pile[j]
        draw_pile[j] = tmp

func draw(n: int) -> void:
    for i in range(n):
        if hand.size() >= HAND_LIMIT:
            return
        if draw_pile.is_empty():
            draw_pile = discard_pile
            discard_pile = []
            shuffle()
            if draw_pile.is_empty():
                return
        var card = draw_pile.pop_back()
        hand.append(card)

func draw_up_to(limit: int) -> void:
    var need := limit - hand.size()
    if need > 0:
        draw(need)

func discard(card) -> void:
    hand.erase(card)
    discard_pile.append(card)
