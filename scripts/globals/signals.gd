extends Node

# Core signals.
signal scene_change(scene_path: String)

# Player signals.
signal tick_passed

# Enemy signals.
signal enemy_destroyed(enemy: Area2D)

# UI signals.
signal score_changed
signal fuel_changed
