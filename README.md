# vbcrypt
A simple bcrypt Library for [V](https://github.com/vlang/v).  
Porting from Golang( golang.org/x/crypto/bcrypt ).

## Installation
```
v install Taillook.vbcrypt
```

## example
```v
module main

import taillook.vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println("hash: $hash")

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
```

to use
```
⫸ v run example.v
hash: $2a$10$QzBXV1pqMDdoMzBjb0NlQgQbw6hVss5qJBvDqFWyzmokG8OoVbLOY
matched password and hash
mismatched hash and password
```
