extends Node3D

@export var quest_to_update : CogitoQuest
enum UpdateType {Start, Complete, Fail, ChangeCounter}
@export var update_type: UpdateType
## Amount by which the quest counter changes. Can be positive or negative.
@export var counter_change: int = 0

var has_been_triggered : bool = false #Used to avoid double-triggering.


func _ready():
	add_to_group("save_object_state")


# Called when the node enters the scene tree for the first time.
func update_quest():
	match update_type:
		UpdateType.Start:
			CogitoQuestManager.start_quest(quest_to_update)
		UpdateType.Complete:
			quest_to_update.update()
			CogitoQuestManager.complete_quest(quest_to_update)
		UpdateType.Start:
			CogitoQuestManager.start_quest(quest_to_update)
		UpdateType.ChangeCounter:
			if has_been_triggered:
				return
			if !CogitoQuestManager.is_quest_active(quest_to_update):
				CogitoQuestManager.start_quest(quest_to_update)
			CogitoQuestManager.change_quest_counter(quest_to_update, counter_change)
			has_been_triggered = true


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("QuestUpdater triggered.")
		update_quest()


func set_state():
	pass
	
func save():
	var state_dict = {
		"node_path" : self.get_path(),
		"has_been_triggered" : has_been_triggered,
		"pos_x" : position.x,
		"pos_y" : position.y,
		"pos_z" : position.z,
		"rot_x" : rotation.x,
		"rot_y" : rotation.y,
		"rot_z" : rotation.z,
		
	}
	return state_dict
