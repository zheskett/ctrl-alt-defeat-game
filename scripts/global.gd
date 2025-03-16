extends Node

enum Crops {EMPTY = 0, BEAN, CORN, CASAVA, YAM, TREE}
static var planted_trees := false
static var year := 1
static var score := 0

signal tree_choice
func make_tree_choice():
	emit_signal("tree_choice")
