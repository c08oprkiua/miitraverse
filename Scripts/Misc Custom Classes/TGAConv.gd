extends RefCounted
class_name TGAConv

#This will probably be moved to elsewhere
static func PaintingToTGA(raw):
	#compressed (gzip?) base64 tga
	var paintingbuffer = Marshalls.base64_to_raw(raw)
	#This max is just gonna be a ridiculously high number cause idk what the
	#actual max size of a painting is tbh
	var paintingbuffer2 = paintingbuffer.decompress_dynamic(10000000, 3)
	var painting = Image.new().load_tga_from_buffer(paintingbuffer2)
	return painting
