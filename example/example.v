module main

import vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println(hash)

	vbcrypt.compare_hash_and_password('password'.bytes(), hash.bytes()) or {
		println(err)
		return
	}
	println('matched password and hash')
}
