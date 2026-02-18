class_name HotSpots extends Node2D

func get_random_hot_spot(agent: NavigationAgent2D):
	var random_spot = get_children().pick_random()
	
	var nav_map = agent.get_navigation_map()
	
	var valid_point = NavigationServer2D.map_get_closest_point(nav_map, random_spot.global_position)
	
	return valid_point
