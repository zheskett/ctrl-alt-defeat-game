extends Node

enum Crops {EMPTY = 0, BEAN, CORN, CASAVA, YAM, TREE}
enum Weathers {TEMPERATE, DROUGHT, FLOOD}

static var weather := Weathers.TEMPERATE
static var planted_trees := false
static var year := 1
static var score := 0

signal tree_choice
func make_tree_choice():
	emit_signal("tree_choice")

func reset():
	weather = Weathers.TEMPERATE
	planted_trees = false
	year = 1
	score = 0
	get_tree().change_scene_to_file("res://main.tscn")
