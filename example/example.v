module main

import example.vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println('hash: $hash')

	vbcrypt.compare_hash_and_password('password'.bytes(), hash.bytes()) or {
		println(err)
		return
	}
	println('matched password and hash')

	vbcrypt.compare_hash_and_password('password2'.bytes(), hash.bytes()) or {
		println(err)
		return
	}
}
