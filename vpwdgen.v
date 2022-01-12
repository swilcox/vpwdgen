import os
import flag
import crypto.rand


fn main() {
	mut words := []string{}
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vpwdgen')
	fp.version('v0.0.1')
	fp.description('V-Powered Password generator')
	fp.skip_executable()
	file_name := fp.string("filename", `f`, "", "filename for source words")
	num_words := fp.int("words", `w`, 4, "number of words")
	separator := fp.string("separator", `s`, "-", "word separator")
	capitalize := fp.int("capitalize", `c`, 1, "word to capitalize")
	number := fp.int("number", `n`, 9, "maximum random number to append (0 = none)")
	show_help := fp.bool("help", `h`, false, "show this help message")

	// show usage
	if show_help {
		println(fp.usage())
		exit(0)
	}

	// get the word list
	if file_name != "" {
		words = os.read_lines(file_name) or {
			exit(1)
		}
	} else {
			words = internal_word_list()
	}

	mut pwords := []string{}

	// pick out the random words
	for _ in 0 .. num_words {		
		pwords << words[rand.int_u64(u64(words.len)) or { 0 }]
	}

	// append a number to the end
	if number > 0 {
		pwords[pwords.len - 1] = pwords[pwords.len - 1] + (rand.int_u64(u64(number)) or {0}).str()
	}

	// capitalize a word
	if capitalize > 0 && capitalize <= pwords.len {
		pwords[capitalize - 1] = pwords[capitalize - 1].capitalize()
	}

	println(pwords.join(separator))
	
}
