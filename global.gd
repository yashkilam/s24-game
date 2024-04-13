extends Node

class_name Game

enum Modes {NORMAL, TRANSFORMAL}
var current_mode : Modes = Modes.NORMAL

var clone_exists = false
var current_clone
