# vbcrypt
A simple bcrypt Library for [V](https://github.com/vlang/v).  
Porting from Golang( golang.org/x/crypto/bcrypt ).

## Installation
```
v install Taillook.vbcrypt
```

## example
```v
import Taillook.vbcrypt

fn main() {
	hash := vbcrypt.generate_from_password('password'.bytes(), 10) or {
		println(err)
		return
	}
	println(hash)
}
```