extends Node
class_name Enemy

var hp: int = 30
var block: int = 0

func take_damage(amount: int) -> void:
    var dmg := max(amount - block, 0)
    block = max(block - amount, 0)
    hp -= dmg

func attack_player(player) -> void:
    player.hp -= 4
