extends PanelContainer
class_name ContentBubble
signal DeleteRequest

@export var Content: PackedScene

func _ready():
	Satellite.connect("NewBubble", NewBubble)
	connect("DeleteRequest", selfdelete)

func NewBubble():
	add_theme_stylebox_override("NewBubble", DaBa.MountedBubble)

func selfdelete():
	self.queue_free()

func ProcessIcon(b64raw):
	if b64raw == null:
		return
	var de64d = Marshalls.base64_to_raw(b64raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var de64d2 = de64d.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(de64d2)
	return ImageTexture.create_from_image(painting)

func PaintingToTGA(post: PostRes):
	#compressed (gzip?) base64 tga
	post.painting
	var raw
	var paintingbuffer = Marshalls.base64_to_raw(raw)
#	#This max is just gonna be a ridiculously high number cause idk what the
#	#actual max size of a painting is tbh
	var paintingbuffer2 = paintingbuffer.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(paintingbuffer2)
	return painting
