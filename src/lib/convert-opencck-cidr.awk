function is_ipv4_cidr(value, parts, address, prefix, octets, i) {
    if (value !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/[0-9]+$/) {
        return 0
    }

    split(value, parts, "/")
    address = parts[1]
    prefix = parts[2] + 0

    if (prefix < 0 || prefix > 32 || parts[2] !~ /^[0-9]+$/) {
        return 0
    }

    if (split(address, octets, ".") != 4) {
        return 0
    }

    for (i = 1; i <= 4; i++) {
        if (octets[i] !~ /^[0-9]+$/ || octets[i] + 0 < 0 || octets[i] + 0 > 255) {
            return 0
        }
    }

    return 1
}

function save_route(cidr) {
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", cidr)
    if (cidr == "") {
        return
    }

    if (!is_ipv4_cidr(cidr)) {
        warnings[++warning_count] = cidr
    } else if (!(cidr in seen)) {
        seen[cidr] = 1
        routes[++count] = cidr
    }
}

function read_string(    c, escape, hex, code, digit) {
    token = ""
    while (position <= line_length) {
        c = substr($0, position++, 1)
        if (c == "\"") {
            return 1
        }

        if (c ~ /[\001-\037]/ || c == nul) {
            return 0
        }

        if (c ~ /[\200-\377]/) {
            if (!match(substr($0, position - 1, 4), utf8_sequence)) {
                return 0
            }
            c = substr($0, position - 1, RLENGTH)
            position += RLENGTH - 1
        }

        if (c == "\\") {
            escape = substr($0, position++, 1)
            if (escape == "u") {
                hex = substr($0, position, 4)
                if (length(hex) != 4 || hex ~ /[^0-9a-fA-F]/) {
                    return 0
                }
                position += 4
                code = 0
                for (digit = 1; digit <= 4; digit++) {
                    code = 16 * code + index("0123456789abcdef", tolower(substr(hex, digit, 1))) - 1
                }

                # Для ключа hostname и IPv4 CIDR достаточно декодировать ASCII.
                # Decoding ASCII is sufficient for the hostname key and IPv4 CIDRs.
                c = (code > 0 && code < 128) ? sprintf("%c", code) : "\\u" hex
            } else if (escape in escapes) {
                c = escapes[escape]
            } else {
                return 0
            }
        }
        token = token c
    }
    return 0
}

function read_token(    c, start) {
    c = substr($0, position++, 1)
    if (c == "\"") {
        return read_string() ? "string" : "invalid"
    }

    if (c ~ /[][{}:,]/) {
        return c
    }

    start = position - 1
    while (position <= line_length && substr($0, position, 1) !~ /[][{}:," \t\r]/) {
        position++
    }

    token = substr($0, start, position - start)
    if (token ~ /^(true|false|null|-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?)$/) {
        return "scalar"
    }
    return "invalid"
}

# Стек отслеживает синтаксис JSON, а hostname читается только из корневого
# объекта или объекта непосредственно в корневом массиве.
# The stack tracks JSON syntax, and hostname is read only from the root object
# or an object directly in the root array.
function accept_token(kind,    current) {
    current = state[depth]

    if ((current == "first_key" || current == "key") && kind == "string") {
        if (depth == record_depth) {
            hostname_key = (token == "hostname")
        }
        state[depth] = "colon"
        return 1
    }

    if (current == "colon" && kind == ":") {
        state[depth] = "value"
        return 1
    }

    if (depth > 0 && current == "after_value" && kind == ",") {
        state[depth] = (container[depth] == "{") ? "key" : "value"
        return 1
    }

    if (depth > 0 && ((container[depth] == "{" && kind == "}" &&
        (current == "first_key" || current == "after_value")) ||
        (container[depth] == "[" && kind == "]" &&
        (current == "first_item" || current == "after_value")))) {
        if (depth == record_depth) {
            save_route(hostname)
            record_depth = 0
        }
        depth--
        return 1
    }

    if (current != "value" && current != "first_item") {
        return 0
    }

    if (depth == 0 && kind != "[" && kind != "{") {
        return 0
    }

    if (depth > 0 && depth == record_depth && hostname_key) {
        hostname = (kind == "string") ? token : ""
    }
    state[depth] = "after_value"

    if (kind == "{" || kind == "[") {
        if (kind == "{" && (depth == 0 || (depth == 1 && container[1] == "["))) {
            record_depth = depth + 1
            hostname = ""
            hostname_key = 0
        }
        container[++depth] = kind
        state[depth] = (kind == "{") ? "first_key" : "first_item"
        return 1
    }

    return kind == "string" || kind == "scalar"
}

BEGIN {
    depth = 0
    state[depth] = "value"
    nul = sprintf("%c", 0)
    utf8_sequence = "^([\302-\337][\200-\277]" \
        "|\340[\240-\277][\200-\277]|[\341-\354\356-\357][\200-\277][\200-\277]|\355[\200-\237][\200-\277]" \
        "|\360[\220-\277][\200-\277][\200-\277]|[\361-\363][\200-\277][\200-\277][\200-\277]|\364[\200-\217][\200-\277][\200-\277])"
    escapes["\""] = "\""
    escapes["\\"] = "\\"
    escapes["/"] = "/"
    escapes["b"] = "\b"
    escapes["f"] = "\f"
    escapes["n"] = "\n"
    escapes["r"] = "\r"
    escapes["t"] = "\t"
}

{
    if (NR == 1) {
        sub(/^\357\273\277/, "")
    }

    line_length = length($0)
    position = 1
    while (position <= line_length) {
        if (substr($0, position, 1) ~ /[ \t\r]/) {
            position++
        } else if (!accept_token(read_token())) {
            malformed = 1
            exit 43
        }
    }
}

END {
    if (malformed || depth != 0 || state[0] != "after_value") {
        print invalid_json > "/dev/stderr"
        exit 43
    }

    for (i = 1; i <= warning_count; i++) {
        print invalid_cidr_prefix warnings[i] > "/dev/stderr"
    }
    if (count == 0) {
        print no_valid_routes > "/dev/stderr"
        exit 42
    }

    print "["

    for (i = 1; i <= count; i++) {
        print "  {"
        printf "    \"hostname\": \"route-%06d.invalid\",\n", i
        printf "    \"ip\": \"%s\"\n", routes[i]

        if (i < count) {
            print "  },"
        } else {
            print "  }"
        }
    }

    print "]"
    count_file = ENVIRON["AMNEZIA_COUNT_FILE"]
    print count > count_file
    if (close(count_file) != 0) {
        exit 1
    }
}
