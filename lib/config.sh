# config parser for steamflags
# sources games.conf and applies sections

apply_section() {
    local target="$1"
    local in_section=false

    while IFS= read -r line; do
        line="${line%%#*}"
        line="${line## }"
        line="${line%% }"
        [[ -z "$line" ]] && continue

        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            [[ "${BASH_REMATCH[1]}" == "$target" ]] && in_section=true || in_section=false
            continue
        fi

        $in_section || continue

        if [[ "$line" == -* ]]; then
            unset "${line#-}"
        elif [[ "$line" == *=* ]]; then
            export "$line"
        fi
    done < "$CONF"
}

scrub_env() {
    local patterns=()
    local in_section=false

    while IFS= read -r line; do
        line="${line%%#*}"
        line="${line## }"
        line="${line%% }"
        [[ -z "$line" ]] && continue

        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            [[ "${BASH_REMATCH[1]}" == "scrub" ]] && in_section=true || in_section=false
            continue
        fi

        $in_section && patterns+=("$line")
    done < "$CONF"

    [[ ${#patterns[@]} -eq 0 ]] && return

    # build combined regex
    local regex
    regex=$(IFS='|'; echo "${patterns[*]}")

    while IFS='=' read -r key _; do
        [[ "$key" =~ $regex ]] && unset "$key"
    done < <(env)
}
