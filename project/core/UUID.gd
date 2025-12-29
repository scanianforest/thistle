class_name UUID extends Node
## AI-generated UUID v4 generator, need to verify correctness


static func v4() -> String:
	var random_bytes: Array[int] = []
	for i in range(16):
		random_bytes.append(randi() % 256)

	# Set the version to 4
	random_bytes[6] = (random_bytes[6] & 0x0F) | 0x40
	# Set the variant to RFC 4122
	random_bytes[8] = (random_bytes[8] & 0x3F) | 0x80

	var hex_parts: Array[String] = []
	for byte in random_bytes:
		hex_parts.append(String("%02x" % byte))

	return (
		"%s%s%s%s-%s%s-%s%s-%s%s-%s%s%s%s%s%s"
		% ([
			hex_parts[0],
			hex_parts[1],
			hex_parts[2],
			hex_parts[3],
			hex_parts[4],
			hex_parts[5],
			hex_parts[6],
			hex_parts[7],
			hex_parts[8],
			hex_parts[9],
			hex_parts[10],
			hex_parts[11],
			hex_parts[12],
			hex_parts[13],
			hex_parts[14],
			hex_parts[15]
		])
	)
