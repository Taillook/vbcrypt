import vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println(hash)
}
