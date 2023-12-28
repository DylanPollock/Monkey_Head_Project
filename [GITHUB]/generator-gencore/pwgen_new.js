var levelDataENG = [
{ name: "N. Sanity Beach",  gem: "clear", passgemid:  0 },
{ name: "Jungle Rollers",   gem: "clear", passgemid:  1 },
{ name: "The Great Gate",   gem: "clear", passgemid:  2 },
{ name: "Boulders",         gem: "clear", passgemid:  3 },
{ name: "Upstream",         gem: "clear", passgemid:  4 },
{ name: "Papu Papu",        gem: "none",  passgemid: -1 },
{ name: "Rolling Stones",   gem: "clear", passgemid:  5 },
{ name: "Hog Wild",         gem: "clear", passgemid:  6 },
{ name: "Native Fortress",  gem: "clear", passgemid:  7 },
{ name: "Up the Creek",     gem: "clear", passgemid:  8 },
{ name: "Ripper Roo",       gem: "none",  passgemid: -1 },
{ name: "The Lost City",    gem: "green", passgemid:  9 },
{ name: "Temple Ruins",     gem: "clear", passgemid: 10 },
{ name: "Road to Nowhere¹", gem: "clear", passgemid: 18 },
{ name: "Boulder Dash",     gem: "clear", passgemid: 11 },
{ name: "Sunset Vista²",    gem: "clear", passgemid: 12 },
{ name: "Koala Kong",       gem: "none",  passgemid: -1 },
{ name: "Heavy Machinery",  gem: "clear", passgemid: 15 },
{ name: "Cortex Power",     gem: "clear", passgemid: 14 },
{ name: "Generator Room",   gem: "orange",passgemid: 16 },
{ name: "Toxic Waste",      gem: "blue",  passgemid: 17 },
{ name: "Pinstripe",        gem: "none",  passgemid: -1 },
{ name: "The High Road¹",   gem: "clear", passgemid: 19 },
{ name: "Slippery Climb²",  gem: "red",   passgemid: 21 },
{ name: "Lights Out",       gem: "purple",passgemid: 20 },
{ name: "Jaws of Darkness", gem: "clear", passgemid: 13 },
{ name: "Castle Machinery", gem: "clear", passgemid: 23 },
{ name: "Nitrus Brio",      gem: "none",  passgemid: -1 },
{ name: "The Lab",          gem: "yellow",passgemid: 22 },
{ name: "The Great Hall",   gem: "none",  passgemid: -1 },
{ name: "Dr. Neo Cortex",   gem: "none",  passgemid: -1 },

{ name: "Fumbling in the Dark",gem: "clear", passgemid: 24 },
{ name: "Whole Hog",        gem: "clear", passgemid: 25 }
]

//               circle    square       x     triangle
var padchars = ["\u25EF", "\u25FB", "\u2715", "\u25B3"];
function stringify(code) {
	var s = '<table><tbody>';
	for (var i = 0; i < code.length; ++i) {
		if (i % 8 == 0) {
			if (i > 0) {
				s += '</tr>';
			}
			s += '<tr>';
		}
		s += '<td style="'
		switch (code[i]) {
			case 0: s += "background: linear-gradient(#ff0000, #800000); -webkit-background-clip: text;"; break;
			case 1: s += "background: linear-gradient(#ff80c4, #804062); -webkit-background-clip: text;"; break;
			case 2: s += "background: linear-gradient(#8080ff, #404080); -webkit-background-clip: text;"; break;
			case 3: s += "background: linear-gradient(#40ff40, #208020); -webkit-background-clip: text;"; break;
		}
		s += '">'+padchars[code[i]]+'</td>';
	}
	s += '</tbody></table>';
	return s;
}

var forcesuper = false;

var passwordDataNormal = {
	modulo: 32399,
	coprime: 11651,
	totient: 32040,
	inverse: 11
};

var passwordDataSuper = {
	modulo: 2021,
	coprime: 773,
	totient: 1932,
	inverse: 5
};

var passwordDataCustom = {
	modulo: 0, // 1. choose a modulo value that you feel should be fit
	coprime: 0, // 2. choose one of its coprimes as the encoding integer
	totient: 0, // 3. calculate the modular inverse of the coprime you chose with the totient of the modulo you chose
	inverse: 0 // 4. you now have the decoding integer
};

function valueEncode(val, passwordData) {
	var passcode = 1;
	var mask = 1<<30;
	for (var i = 0; i < 31; ++i) {
		passcode = passcode*passcode % passwordData.modulo;
		if ((passwordData.coprime & mask) != 0) {
			passcode = passcode*val % passwordData.modulo;
		}
		mask >>= 1;
	}
	return passcode;
}

function valueDecode(val, passwordData) {
	var passcode = 1;
	var mask = 1<<30;
	for (var i = 0; i < 31; ++i) {
		passcode = passcode*passcode % passwordData.modulo;
		if ((passwordData.inverse & mask) != 0) {
			passcode = passcode*val % passwordData.modulo;
		}
		mask >>= 1;
	}
	return passcode;
}

function makePassword(levels, keys, gems) {
	console.log('Levels: '+levels+'\nKeys: '+keys+'\nGems: '+gems);
	var password = new Object();
	if (gems == 0 && !forcesuper) {
		console.log("Encoding normal password...");
		password.superpass = false;
		password.code1 = 0x18D ^ valueEncode(levels | (keys << 5), passwordDataNormal);
	}
	else {
		console.log("Encoding super password...");
		password.superpass = true;
		var code1 = valueEncode(levels | (keys << 5) | ((gems & 0x3) << 7), passwordDataSuper);
		var code2 = valueEncode((gems & (0x1FF<<2))>>2, passwordDataSuper);
		var code3 = valueEncode((gems & (0x1FF<<11))>>11, passwordDataSuper);
		var code4 = valueEncode((gems & (0x3F<<20))>>20, passwordDataSuper);
		code1 ^= 0x18D;
		code2 ^= 0x24E;
		code3 ^= 0x3E4;
		code4 ^= 0x139;
		var newcode1 = code1 ^ code2 ^ code3;
		var newcode2 = code2 ^ code3 ^ code4;
		var newcode3 = code3 ^ code4 ^ code1;
		var newcode4 = code4 ^ code1 ^ code2;
		password.code1 = newcode1 | (newcode2 << 11);
		password.code2 = newcode3 | (newcode4 << 11);
	}
	return password;
}

function typePassword(password) {
	var chars = [];
	if (password.superpass == true || forcesuper == true) {
		chars[0] = 3; chars[1] = 3;
		for (var i = 0; i < 11; ++i) {
			chars[2+i] = (password.code1 & (0x3 << i*2)) >> i*2;
		}
		for (var i = 0; i < 11; ++i) {
			chars[13+i] = (password.code2 & (0x3 << i*2)) >> i*2;
		}
	}
	else {
		switch (password.code1 & 0x7) {
			case 0: chars[0] = 0; chars[1] = 0; break;
			case 1: chars[0] = 0; chars[1] = 1; break;
			case 2: chars[0] = 0; chars[1] = 2; break;
			case 3: chars[0] = 1; chars[1] = 0; break;
			case 4: chars[0] = 1; chars[1] = 1; break;
			case 5: chars[0] = 1; chars[1] = 2; break;
			case 6: chars[0] = 2; chars[1] = 0; break;
			case 7: chars[0] = 2; chars[1] = 1; break;
		}
		for (var i = 0; i < 6; ++i) {
			chars[2+i] = (password.code1 & (0x3 << (3+i*2))) >> (3+i*2);
		}
	}
	return chars;
}

