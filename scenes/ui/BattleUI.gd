extends Control
class_name BattleUI
# Handles battle UI and mediates question prompts.

var battle: Battle

@onready var player_label: Label = $TopBar/PlayerStats
@onready var enemy_label: Label = $TopBar/EnemyStats
@onready var hand_container: HBoxContainer = $Hand
@onready var end_turn_button: Button = $EndTurn

func _ready() -> void:
    end_turn_button.pressed.connect(func(): Events.end_turn_requested.emit())
    Events.request_question.connect(_on_request_question)

func refresh() -> void:
    update_stats()
    refresh_hand()

func update_stats() -> void:
    if battle == null:
        return
    player_label.text = "HP: %d | EN: %d" % [battle.player.hp, battle.player.energy]
    enemy_label.text = "Enemy HP: %d | BL: %d" % [battle.enemy.hp, battle.enemy.block]

func refresh_hand() -> void:
    for c in hand_container.get_children():
        c.queue_free()
    if battle == null:
        return
    var card_scene := preload("res://scenes/ui/CardUI.tscn")
    for card in battle.player.hand:
        var ui := card_scene.instantiate()
        ui.setup(card, battle.player, [battle.enemy])
        hand_container.add_child(ui)

func _on_request_question(card, targets, stats) -> void:
    var q_scene := preload("res://scenes/ui/QuestionUI.tscn")
    var ui := q_scene.instantiate()
    add_child(ui)
    ui.answered.connect(func(correct: bool):
        if correct:
            _apply_correct_effects(card, targets, stats)
        else:
            _apply_incorrect_effects(card, targets, stats)
        ui.queue_free()
        Events.card_resolved.emit(card)
    )
    ui.show_question(card, targets, stats)

func _apply_correct_effects(card, targets, stats) -> void:
    for t in targets:
        if t != null and t.has_method("take_damage"):
            t.take_damage(5 + 3 * card.difficulty)
    if battle != null and battle.has_method("register_answer"):
        battle.register_answer(true)

func _apply_incorrect_effects(card, targets, stats) -> void:
    if stats != null:
        if stats.has_method("take_damage"):
            stats.take_damage(3)
        elif stats.has_property("hp"):
            stats.hp -= 3
    if battle != null and battle.has_method("register_answer"):
        battle.register_answer(false)
