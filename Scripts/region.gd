extends NavigationRegion2D

func _ready():
	await get_tree().process_frame
	print("Region map:", get_navigation_map())
