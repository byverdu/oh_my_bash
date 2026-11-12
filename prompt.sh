# Separator character
SEPARATOR=""

# Function to map exit code to a reason
get_error_reason() {
    local code=$1
    local reason=""
    case "$code" in
        1) reason="Error";;
        2) reason="Usage";;
        126) reason="No Perms";;
        127) reason="Not Found";;
        130) reason="Canceled";; # Corresponds to Ctrl+C
        *) reason="$code";;
    esac
    echo "$reason"
}

build_prompt_segment() {
    local OLD_BG_NAME="$1"
    local BG="$2"
    local FG="$3"
    local CONTENT="$4"

    if [[ -n "$OLD_BG_NAME" ]]; then
        # Draw separator with the color of the previous segment's background
        echo -n "${FG_COLORS[$OLD_BG_NAME]}${BG_COLORS[$BG]}$SEPARATOR${RESET_CODE}"
    fi

    # Draw segment
    echo -n "${BG_COLORS[$BG]}${FG_COLORS[$FG]} $CONTENT ${RESET_CODE}"
}

# ANSI color codes for PROMPT_SUBST
declare -A FG_COLORS BG_COLORS
FG_COLORS[black]="\033[30m"
FG_COLORS[red]="\033[31m"
FG_COLORS[green]="\033[32m"
FG_COLORS[yellow]="\033[33m"
FG_COLORS[blue]="\033[34m"
FG_COLORS[magenta]="\033[35m"
FG_COLORS[cyan]="\033[36m"
FG_COLORS[white]="\033[37m"
FG_COLORS[bold_white]="\033[1;37m"
FG_COLORS[bold_green]="\033[1;32m"
FG_COLORS[dark_blue]="\033[38;5;25m"
FG_COLORS[dark_yellow]="\033[38;5;178m"
FG_COLORS[none]="\033[39m"

BG_COLORS[black]="\033[40m"
BG_COLORS[red]="\033[41m"
BG_COLORS[green]="\033[42m"
BG_COLORS[yellow]="\033[43m"
BG_COLORS[blue]="\033[44m"
BG_COLORS[magenta]="\033[45m"
BG_COLORS[cyan]="\033[46m"
BG_COLORS[white]="\033[47m"
BG_COLORS[dark_blue]="\033[48;5;25m"
BG_COLORS[dark_yellow]="\033[48;5;178m"
BG_COLORS[none]="\033[49m"  # terminal default background

RESET_CODE="\033[0m"

# Enable command substitution in prompts
setopt PROMPT_SUBST

# Modified build_prompt function that returns the prompt instead of setting PS1
build_prompt() {
    # Store exit code
    EXIT_CODE=$?

    local segments=()
    local bgs=()
    local fgs=()
    local bg_color_names=()
    local last_segment_is_git=false

    # Username and time
    segments+=("%n@$(date +'%H:%M')")
    bgs+=("dark_blue")
    fgs+=("bold_white")
    bg_color_names+=("dark_blue")
    last_segment_is_git=false

    # Current directory
    segments+=("$(pwd | sed "s|$HOME|~|")")
    bgs+=("dark_yellow")
    fgs+=("black")
    bg_color_names+=("dark_yellow")
    last_segment_is_git=false

    # Git information
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n $git_branch ]]; then
        local git_status=$(git status --porcelain 2>/dev/null)
        local git_status_icons=""

        if [[ -n "$git_status" ]]; then
            # Dirty repo: check for status and add icons
            if echo "$git_status" | grep -q "A "; then git_status_icons+="${FG_COLORS[green]}✚ "; fi
            if echo "$git_status" | grep -q "M";   then git_status_icons+="${FG_COLORS[blue]}✹ "; fi
            if echo "$git_status" | grep -q "D "; then git_status_icons+="${FG_COLORS[red]}✖ "; fi
            if echo "$git_status" | grep -q "R "; then git_status_icons+="${FG_COLORS[magenta]}➜ "; fi
            if echo "$git_status" | grep -q "UU";  then git_status_icons+="${FG_COLORS[yellow]}═ "; fi
            if echo "$git_status" | grep -q "??";  then git_status_icons+="${FG_COLORS[cyan]}✭ "; fi

            # Trim trailing space
            git_status_icons=${git_status_icons%% }

            segments+=(" $git_branch $git_status_icons")
            bgs+=("none")
            fgs+=("bold_white")
            bg_color_names+=("none")
        else
            # Clean repo
            segments+=(" $git_branch ${FG_COLORS[bold_green]}✔")
            bgs+=("none")
            fgs+=("bold_white")
            bg_color_names+=("none")
        fi
        last_segment_is_git=true
    fi

    # Exit code
    if [[ $EXIT_CODE -ne 0 ]]; then
        local error_reason=$(get_error_reason $EXIT_CODE)
        segments+=("👻 $error_reason")
        bgs+=("red")
        fgs+=("white")
        bg_color_names+=("red")
        last_segment_is_git=false
    fi

    # Build the prompt line
    local prompt_line=""
    local last_bg_name=""
    for i in {1..${#segments[@]}}; do
        prompt_line+=$(build_prompt_segment "$last_bg_name" "${bgs[i]}" "${fgs[i]}" "${segments[i]}")
        last_bg_name=${bg_color_names[i]}
    done

    # Final separator
    if [[ "$last_segment_is_git" = false && -n "$last_bg_name" ]]; then
        prompt_line+="${FG_COLORS[$last_bg_name]}$SEPARATOR$RESET_CODE"
    fi

    # Return the prompt instead of setting it
    printf "%b" "$prompt_line"
}

# Set the prompt to call the function dynamically
PS1='$(build_prompt)
❯ '
