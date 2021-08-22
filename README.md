# vbcrypt
A simple bcrypt Library for VLang.  
Porting from Golang( golang.org/x/crypto/bcrypt ).

## Installation
```
v install Taillook.vbcrypt
```

## example
```v
import vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println(hash)
}
```