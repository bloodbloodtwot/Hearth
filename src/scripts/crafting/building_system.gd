extends Node3D

# Building System - Tile placement and morphing

class_name BuildingSystem

# Tile database
var tile_prefabs: Dictionary = {}
var placed_tiles: Array = []

# Selection
var selected_material: String = "wool"
var selected_color: Color = Color(0.9, 0.8, 0.7, 1.0)

# Grid settings
var grid_size: float = 1.0
var max_height: float = 10.0

func _ready():
	setup_tile_prefabs()
	print("BuildingSystem initialized")

func setup_tile_prefabs():
	"""Setup available tile types"""
	tile_prefabs = {
		"cube": {
			"mesh": BoxMesh.new(),
			"size": Vector3(1, 1, 1),
			"cost": 10
		},
		"slab": {
			"mesh": BoxMesh.new(),
			"size": Vector3(1, 0.5, 1),
			"cost": 5
		},
		"stair": {
			"mesh": BoxMesh.new(),
			"size": Vector3(1, 1, 1),
			"cost": 15
		},
		"pillar": {
			"mesh": CylinderMesh.new(),
			"size": Vector3(0.5, 2, 0.5),
			"cost": 20
		},
		"arch": {
			"mesh": BoxMesh.new(),
			"size": Vector3(1, 2, 1),
			"cost": 25
		}
	}

func place_tile(tile_type: String, position: Vector3, material: String = "wool", color: Color = Color.WHITE) -> Node3D:
	"""Place a tile at a position"""
	if tile_type not in tile_prefabs:
		print("Unknown tile type: %s" % tile_type)
		return null
	
	var tile_data = tile_prefabs[tile_type]
	var tile = MeshInstance3D.new()
	
	tile.mesh = tile_data["mesh"]
	tile.position = position
	tile.scale = tile_data["size"]
	
	# Create material
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	tile.set_surface_override_material(0, mat)
	
	add_child(tile)
	
	# Store tile info
	var tile_info = {
		"node": tile,
		"type": tile_type,
		"position": position,
		"material": material,
		"color": color
	}
	placed_tiles.append(tile_info)
	
	print("Placed %s tile at %s" % [tile_type, position])
	return tile

func remove_tile(tile: Node3D):
	"""Remove a placed tile"""
	for i in range(placed_tiles.size()):
		if placed_tiles[i]["node"] == tile:
			placed_tiles.remove_at(i)
			tile.queue_free()
			print("Removed tile")
			break

func morph_tile(tile: Node3D, new_size: Vector3):
	"""Morph a tile to a new size"""
	tile.scale = new_size

func get_tiles_at(position: Vector3, radius: float = 1.0) -> Array:
	"""Get tiles near a position"""
	var nearby = []
	for tile_info in placed_tiles:
		var dist = tile_info["node"].global_position.distance_to(position)
		if dist <= radius:
			nearby.append(tile_info)
	return nearby

func save_building_layout() -> Array:
	"""Save current building layout"""
	var layout = []
	for tile_info in placed_tiles:
		layout.append({
			"type": tile_info["type"],
			"position": tile_info["position"],
			"material": tile_info["material"],
			"color": tile_info["color"]
		})
	return layout

func load_building_layout(layout: Array):
	"""Load a saved building layout"""
	# Clear existing
	for tile_info in placed_tiles:
		tile_info["node"].queue_free()
	placed_tiles.clear()
	
	# Place new tiles
	for tile_data in layout:
		place_tile(tile_data["type"], tile_data["position"], tile_data["material"], tile_data["color"])
