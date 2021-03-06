extends "res://Scripts/Characters/PossessCharacter.gd"

export var cast_spell_time = 0.2
export var spell_cooldown = 0.5
export var push_back = 20

var can_cast_projectile = true
onready var projectile = load("res://Scenes/GameObjects/Characters/Projectile.tscn")

func _ready():
	$Timer.connect("timeout", self, "send_projectile")
	$SpellCoolDown.connect("timeout", self, "can_cast_spells_again")
	$Glyph.modulate = Color(1.0, 1.0, 1.0, 0.0)

func can_cast_spells_again():
	can_cast_projectile = true

func send_projectile():
	var new_proj = projectile.instance()
	get_parent().add_child(new_proj)
	new_proj.set_facing(facing)
	new_proj.position = position
	set_glyph_invisible()
	x_speed -= push_back * facing
	
	$CharacterAudio.play_sound("cast")
	$SpellCoolDown.start(spell_cooldown)

func set_glyph_invisible():
	$Tween.interpolate_property(
		$Glyph,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()

func set_glyph_visible():
	$Tween.interpolate_property(
		$Glyph,
		"modulate",
		Color(1.0, 1.0, 1.0, 0.0),
		Color(1.0, 1.0, 1.0, 1.0),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

	$Tween.start()

func process_special():
	if can_cast_projectile:
		can_cast_projectile = false
		set_glyph_visible()
		$Timer.start(cast_spell_time)

func get_id():
	return 3
