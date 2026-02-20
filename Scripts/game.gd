class_name GameManager extends Node2D

@onready var g_bounds: Array[Marker2D] = [%TopLeft, %TopRight, %BottomLeft, %BottomRight]
@onready var m_bounds: Array[Marker2D] = [%M_TopLeft, %M_TopRight, %M_BottomLeft, %M_BottomRight]

@export var hot_spots: HotSpots

enum BOUND
{
	General,
	MilitaryBase
}

func get_random_nav_point(nav_agent: NavigationAgent2D, bound: BOUND) -> Vector2:
	var bounds: Array[Marker2D]
	
	match bound:
		BOUND.General:
			bounds = g_bounds
		BOUND.MilitaryBase:
			bounds = m_bounds
	
	var top_left = bounds[0].global_position
	var top_right = bounds[1].global_position
	var bottom_left = bounds[2].global_position
	
	var min_x = top_left.x
	var max_x = top_right.x
	var min_y = top_left.y
	var max_y = bottom_left.y
	
	var random_point = Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)
	
	var nav_map = nav_agent.get_navigation_map()
	
	var valid_point = NavigationServer2D.map_get_closest_point(nav_map, random_point)
	
	return valid_point

func get_disruption_manager() -> DisruptionManager:
	return %DisruptionManager


func _on_player_on_death() -> void:
	await get_tree().create_timer(2.0).timeout
	call_deferred("_go_to_menu")
	
func _go_to_menu():
	SceneManager.change_scene("res://Scenes/menu.tscn")
