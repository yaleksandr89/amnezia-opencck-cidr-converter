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

function finish_string() {
    if (string_role == "key") {
        current_key = token
        state = "after_key"
    } else if (string_role == "value") {
        if (current_key == "hostname") {
            cidr = token
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", cidr)

            if (cidr != "") {
                if (!is_ipv4_cidr(cidr)) {
                    print invalid_cidr_prefix cidr > "/dev/stderr"
                } else if (!(tolower(cidr) in seen)) {
                    count++
                    seen[tolower(cidr)] = 1
                    routes[count] = cidr
                }
            }
        }

        state = "after_value"
    }

    token = ""
    string_role = ""
}

BEGIN {
    state = "search_key"
    in_string = 0
    escape = 0
    token = ""
    count = 0
}

{
    line = $0 "\n"

    for (i = 1; i <= length(line); i++) {
        c = substr(line, i, 1)

        if (in_string) {
            if (escape) {
                token = token c
                escape = 0
            } else if (c == "\\") {
                escape = 1
            } else if (c == "\"") {
                in_string = 0
                finish_string()
            } else {
                token = token c
            }

            continue
        }

        if (state == "search_key") {
            if (c == "\"") {
                in_string = 1
                string_role = "key"
                token = ""
            }
        } else if (state == "after_key") {
            if (c ~ /[[:space:]]/) {
                continue
            }

            if (c == ":") {
                state = "before_value"
            } else {
                state = "search_key"
            }
        } else if (state == "before_value") {
            if (c ~ /[[:space:]]/) {
                continue
            }

            if (c == "\"") {
                in_string = 1
                string_role = "value"
                token = ""
            } else {
                state = "after_value"
            }
        } else if (state == "after_value") {
            if (c == "," || c == "}") {
                state = "search_key"
                current_key = ""
            }
        }
    }
}

END {
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
    print count > count_file
}
