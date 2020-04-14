tool
extends Control



const COLLISION_TRIMESH = 'TRIMESH'
const COLLISION_CONVEX = 'CONVEX'
var meshes = {}

func _ready():
	$ButtonsContainer/Button.connect("button_up", self, 'create')
	$ButtonsContainer/ButtonRemove.connect("button_up", self, 'remove')
	$ButtonsContainer/UpdataNodeList.connect("button_down", self, 'update_node_list')
	
func create():
	var context = get_tree().get_edited_scene_root()
	var node_list = $ButtonsContainer/ScrollContainer/NodeList
	if node_list.get_child_count() == 0:
		for node in context.get_children():
			if node is MeshInstance:
				print(node.name)
				create_collision(node)
	else:
		for node in node_list.get_children():
			if node is CheckButton:
				create_collision(meshes[node.text], node.is_pressed())

func create_collision(node, is_convex= false):
	if is_convex:
		return node.create_convex_collision()
	
	return node.create_trimesh_collision()
func remove():
	var context = get_tree().get_edited_scene_root()
	
	for node in context.get_children():
		if node is MeshInstance:
			for child in node.get_children():
				child.free()


func remove_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func update_node_list():
	var context = get_tree().get_edited_scene_root()
	var node_list = $ButtonsContainer/ScrollContainer/NodeList
	remove_children(node_list)
	meshes = {}
	var label = Label.new()
	label.text ='Name | is convex (Trimesh)'
	node_list.add_child(label)

	for node in context.get_children():
		var node_name = node.get_name()
		if node is MeshInstance:
			meshes[node_name] = node
			var check = CheckButton.new()
			check.text = node.get_name()
			node_list.add_child(check)

