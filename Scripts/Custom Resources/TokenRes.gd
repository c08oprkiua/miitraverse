extends Resource
class_name TokenRes

#The benefit of us having this is being able to edit it on the fly, as well as
#knowing when exactly the current token expires to request a new one

@export var system_type: int
@export var token_type: int
@export var pid: int
@export var access_level: int
@export var title_id: int
@export var expire_time: int
