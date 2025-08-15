extends Control
class_name BattleUI

var battle: Battle

@onready var player_label: Label = $TopBar/PlayerStats
@onready var enemy_label: Label = $TopBar/EnemyStats
@onready var hand_container: HBoxContainer = $Hand
@onready var end_turn_button: Button = $EndTurn

func _ready() -> void:
    end_turn_button.pressed.connect(func(): Events.end_turn_requested.emit())

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

func show_question(card: QuestionCard) -> void:
    var q_scene := preload("res://scenes/ui/QuestionUI.tscn")
    var ui := q_scene.instantiate()
    add_child(ui)
    ui.show_question(card)
    ui.answered.connect(func(correct: bool):
        if correct:
            battle.enemy.take_damage(5 + 3 * card.difficulty)
        else:
            battle.player.hp -= 3
        battle.register_answer(correct)
        ui.queue_free()
        Events.card_resolved.emit(card)
    )
