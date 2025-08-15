extends Node
class_name Battle

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var ui: BattleUI = $CanvasLayer/BattleUI

var wrong_answered: bool = false

func _ready() -> void:
    ui.battle = self
    player.build_starting_deck()
    player.shuffle()
    player.draw(5)
    ui.refresh()
    Events.request_question.connect(_on_request_question)
    Events.card_resolved.connect(_on_card_resolved)
    Events.end_turn_requested.connect(_on_end_turn_requested)

func register_answer(correct: bool) -> void:
    if not correct:
        wrong_answered = true

func _on_request_question(card, targets, stats) -> void:
    ui.show_question(card)

func _on_card_resolved(card) -> void:
    player.discard(card)
    ui.refresh()

func _on_end_turn_requested() -> void:
    if wrong_answered:
        enemy.attack_player(player)
        wrong_answered = false
    player.draw_up_to(5)
    player.energy = 3
    ui.refresh()
