extends CanvasLayer

# UI Layer - Updated to include game over screen

class_name UILayer

@onready var score_label = $HUD/ScoreLabel
@onready var combo_label = $HUD/ComboLabel
@onready var speed_label = $HUD/SpeedLabel
@onready var health_label = $HUD/HealthLabel

var game_over_label: Label = null

func _ready():
	update_hud(0, 0, 10, 3)

func update_hud(score: int, combo: int, speed: int, health: int):
	"""Update all HUD elements"""
	if score_label:
		score_label.text = "Score: %d" % score
	if combo_label:
		combo_label.text = "Combo: %d" % combo
	if speed_label:
		speed_label.text = "Speed: %d" % speed
	if health_label:
		health_label.text = "Health: %d/3" % health

func show_game_over(final_score: int):
	"""Display game over screen"""
	if not game_over_label:
		game_over_label = Label.new()
		game_over_label.add_theme_font_size_override("font_size", 48)
		game_over_label.text = "GAME OVER\nFinal Score: %d\n\nPress SPACE to restart" % final_score
		game_over_label.anchor_left = 0.5
		game_over_label.anchor_top = 0.5
		game_over_label.anchor_right = 0.5
		game_over_label.anchor_bottom = 0.5
		game_over_label.offset_left = -200
		game_over_label.offset_top = -100
		game_over_label.custom_minimum_size = Vector2(400, 200)
		$HUD.add_child(game_over_label)
