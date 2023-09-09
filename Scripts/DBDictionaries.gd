extends Node
#Welcome to the information dump script, where a whole lot of dictionaries for various things get dumped
# for the sake of readability, and so that they don't bloat up other scripts.

#Information dictionaries for the x-nintendo-parampack header
const platforms = {
	
	
}

const regions = {
	
	
	
	
}

const languages = {
	"ja": 0,
	"en": 1,
	"fr": 2,
	"de": 3,
	"it": 4,
	"es": 5,
	"zh": 6,
	"ko": 7,
	"nl": 8,
	"pt": 9,
	"ru": 10,
}

const countries = {}

const areas = {}

#Information for server response codes and what they mean. Usually only for debugging,
# but will show up in a small error bubble if it interferes with app usage.

const responses = {
	100: "continue",
	101: "switching_protocols",
	
}
