extends Resource
class_name ParamPack
#Welcome to the information dump script, where a whole lot of dictionaries for the
#param-pack get dumped, so that they don't bloat up other scripts.

#Information dictionaries for the x-nintendo-parampack header
const Platform_ID = {
	"WiiU": 1,
	"3DS": 2,
}

const regions = {
	
	
	
	
}

enum languages {
	ja,
	en,
	fr, 
	de,
	it,
	es,
	zh,
	ko,
	nl,
	pt,
	ru,
}

const countries = {
	
	
}

const areas = {
	
}

#Information for server response codes and what they mean. Usually only for debugging,
# but will show up in a small error bubble if it interferes with app usage.

const responses = {
	100: "continue",
	101: "switching_protocols",
	
}
