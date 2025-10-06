@tool
extends EditorScript

var path = "res://assets/level_imports/"
var file_name = "level_test"
var file_extension = "glb"

var tecido_script : Script = preload("res://scripts/surfaces/tecido.gd")
var madeira_script : Script = preload("res://scripts/surfaces/madeira.gd")
var estofado_script : Script = preload("res://scripts/surfaces/estofado.gd")
var rampa_script : Script = preload("res://scripts/surfaces/rampa.gd")

func _run() -> void:
	var scene_path = path + file_name + "." + file_extension
	var packed_scene: PackedScene = ResourceLoader.load(scene_path, "PackedScene")
	if packed_scene == null:
		push_error("Failed to load GLB file: " + scene_path)
		return

	var scene_instance: Node = packed_scene.instantiate()
	if scene_instance == null:
		push_error("Failed to instantiate scene.")
		return
	# Apply any transformations here
	scene_instance.scale = Vector3(1.0, 1.0, 1.0)
	
	var scene_children : Array[Node] = scene_instance.get_children()
	
	var static_body = StaticBody3D.new()
	static_body.name = "level_static_body"
	
	scene_instance.add_child(static_body)
	static_body.set_owner(scene_instance)
	
	for node in scene_children:
		var node_name = node.get_name()
		var name_parts = node_name.split("_")
		for i in range(len(name_parts)):
			name_parts[i] = name_parts[i].to_lower()
			name_parts[i] = name_parts[i].split(".")[0]
		
		if node.get_class() == "MeshInstance3D":
			var node_mesh : MeshInstance3D = node.duplicate()
			if "collider" in name_parts: 
				var collider = CollisionShape3D.new()
				collider.set_name("%s_collider"%name_parts[0])
				collider.shape = node_mesh.mesh.create_trimesh_shape()
				static_body.add_child(collider)
				collider.set_owner(scene_instance)
				collider.position = node.position
				collider.add_child(node_mesh)
				node_mesh.position = Vector3.ZERO
				node_mesh.set_owner(scene_instance)
				if "invisible" in name_parts:
					collider.remove_child(node_mesh)
				if "tecido" in name_parts:
					collider.set_script(tecido_script)
				elif "madeira" in name_parts:
					collider.set_script(madeira_script)
				elif "estofado" in name_parts:
					collider.set_script(estofado_script)
				elif "rampa" in name_parts:
					collider.set_script(rampa_script)
			else:
				static_body.add_child(node_mesh)
			scene_instance.remove_child(node)
		elif node.get_class() == "Node3D":
			if "refill" in name_parts:
				pass
	scene_children = scene_instance.get_children()
	
	# Create a new PackedScene and pack the node
	var new_packed_scene = PackedScene.new()
	var error = new_packed_scene.pack(scene_instance)
	if error != OK:
		push_error("Failed to pack scene: " + str(error))
		return
	
	# Save the packed scene as a .tscn file
	var output_path = path + file_name + ".tscn"
	error = ResourceSaver.save(new_packed_scene, output_path)
	if error != OK:
		push_error("Failed to save scene: " + str(error))
	else:
		print("Scene saved to: " + output_path)
	
	# Clean up
	scene_instance.queue_free()
