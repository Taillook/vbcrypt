module vbcrypt

import encoding.base64
import rand
import blowfish

const (
	min_cost              = 4
	max_cost              = 31
	default_cost          = 10
	solt_length           = 16
	max_crypted_hash_size = 23
	encoded_salt_size     = 22
	encoded_hash_size     = 31

	major_version         = '2'
	minor_version         = 'a'
)

pub struct Hashed {
mut:
	hash  []byte
	salt  []byte
	cost  int
	major string
	minor string
}

const magic_cipher_data = [byte(0x4f727068), 0x65616e42, 0x65686f6c, 0x64657253, 0x63727944,
	0x6f756274,
]

pub fn generate_from_password(password []byte, cost int) ?string {
	mut cost_ := cost
	mut p := new_from_password(password, mut cost_) or { return error('Error: $err') }

	return string(p.hash_byte())
}

pub fn generate_salt() string {
	salt_source := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQLSTUVWXYZ0123456789'
	return rand.string_from_set(salt_source, solt_length)
}

fn new_from_password(password []byte, mut cost &int) ?&Hashed {
	if cost < min_cost {
		cost = default_cost
	}
	mut p := Hashed{}
	p.major = major_version
	p.minor = minor_version

	if cost < min_cost || cost > max_cost {
		return error('invalid cost')
	}
	p.cost = cost

	p.salt = base64.encode(generate_salt().bytes()).bytes()
	hash := bcrypt(password, p.cost, p.salt) or { return error('err') }
	p.hash = hash
	return &p
}

fn bcrypt(password []byte, cost int, salt []byte) ?[]byte {
	mut cipher_data := []byte{len: 72 - magic_cipher_data.len, init: 0}
	cipher_data << magic_cipher_data

	mut bf := expensive_blowfish_setup(password, u32(cost), salt) or { return error('err') }

	for i := 0; i < 24; i += 8 {
		for j := 0; j < 64; j++ {
			bf.encrypt(mut cipher_data[i..i + 8], cipher_data[i..i + 8])
		}
	}

	hsh := base64.encode(cipher_data[..max_crypted_hash_size])
	return hsh.bytes()
}

fn expensive_blowfish_setup(key []byte, cost u32, salt []byte) ?&blowfish.Blowfish {
	csalt := base64.decode(string(salt))

	mut bf := blowfish.new_salted_cipher(key, csalt) or { return error('err') }

	mut i := u64(0)
	mut rounds := u64(0)
	rounds = 1 << cost
	for i = 0; i < rounds; i++ {
		blowfish.expand_key(key, mut bf)
		blowfish.expand_key(csalt, mut bf)
	}

	return &bf
}

fn (mut h Hashed) hash_byte() []byte {
	mut arr := []byte{len: 60, init: 0}
	arr[0] = '$'.bytes()[0]
	arr[1] = h.major.bytes()[0]
	mut n := 2
	if h.minor != '0' {
		arr[2] = h.minor.bytes()[0]
		n = 3
	}
	arr[n] = '$'.bytes()[0]
	n++
	copy(arr[n..], '${int(h.cost):02}'.bytes())
	n += 2
	arr[n] = '$'.bytes()[0]
	n++
	copy(arr[n..], h.salt)
	n += encoded_salt_size
	copy(arr[n..], h.hash)
	n += encoded_hash_size
	return arr[..n]
}
