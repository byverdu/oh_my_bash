# Custom Agnoster-inspired theme for zsh
# Features:
# - Username and time
# - Current directory with truncation
# - Git branch and status
# - Exit code for failed commands
# - Color-coded segments

# Color definitions
autoload -U colors && colors

# Segment color names
C_USER_BG_NAME="blue"
C_PATH_BG_NAME="yellow"
C_GIT_BG_NAME="yellow"
C_GIT_DIRTY_BG_NAME="black"
C_EXIT_BG_NAME="red" # red

# Segment colors
SEGMENT_USER_BG="%{$bg[$C_USER_BG_NAME]%}"
SEGMENT_USER_FG="%{$fg[black]%}"
SEGMENT_PATH_BG="%{$bg[$C_PATH_BG_NAME]%}"
SEGMENT_PATH_FG="%{$fg[black]%}"
SEGMENT_GIT_BG="%{$bg[$C_GIT_BG_NAME]%}"
SEGMENT_GIT_FG="%{$fg[black]%}"
SEGMENT_GIT_DIRTY_BG="%{$bg[black]%}"
SEGMENT_GIT_DIRTY_FG="%{$fg_bold[white]%}"
SEGMENT_EXIT_BG="%{$bg[$C_EXIT_BG_NAME]%}"
SEGMENT_EXIT_FG="%{$fg[white]%}"
SEGMENT_TIME_BG="%{$bg[magenta]%}"
SEGMENT_TIME_FG="%{$fg[white]%}"

# Reset colors
RESET="%{$reset_color%}"

# Git status icons and colors from custom.sh
GIT_ICON_CLEAN="%{$fg_bold[green]%}✔"
GIT_ICON_ADDED="%{$fg[green]%}✚"
GIT_ICON_MODIFIED="%{$fg[blue]%}✹"
GIT_ICON_DELETED="%{$fg[red]%}✖"
GIT_ICON_RENAMED="%{$fg[magenta]%}➜"
GIT_ICON_UNMERGED="%{$fg[yellow]%}═"
GIT_ICON_UNTRACKED="%{$fg[cyan]%}✭"

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
        echo -n "%{$fg[$OLD_BG_NAME]%}%{$BG%}$SEPARATOR%{$reset_color%}"
    fi

    # Draw segment
    echo -n "%{$BG%}%{$FG%} $CONTENT %{$reset_color%}"
}

# Main prompt function
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
    bgs+=("$SEGMENT_USER_BG")
    fgs+=("$SEGMENT_USER_FG")
    bg_color_names+=("$C_USER_BG_NAME")
    last_segment_is_git=false

    # Current directory
    segments+=("$(pwd | sed "s|$HOME|~|")")
    bgs+=("$SEGMENT_PATH_BG")
    fgs+=("$SEGMENT_PATH_FG")
    bg_color_names+=("$C_PATH_BG_NAME")
    last_segment_is_git=false

    # Git information
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n $git_branch ]]; then
        local git_status=$(git status --porcelain 2>/dev/null)
        local git_status_icons=""

        if [[ -n "$git_status" ]]; then
            # Dirty repo: check for status and add icons
            if echo "$git_status" | grep -q "A "; then git_status_icons+="$GIT_ICON_ADDED "; fi
            if echo "$git_status" | grep -q "M";   then git_status_icons+="$GIT_ICON_MODIFIED "; fi
            if echo "$git_status" | grep -q "D "; then git_status_icons+="$GIT_ICON_DELETED "; fi
            if echo "$git_status" | grep -q "R "; then git_status_icons+="$GIT_ICON_RENAMED "; fi
            if echo "$git_status" | grep -q "UU";  then git_status_icons+="$GIT_ICON_UNMERGED "; fi
            if echo "$git_status" | grep -q "??";  then git_status_icons+="$GIT_ICON_UNTRACKED "; fi

            # Trim trailing space
            git_status_icons=${git_status_icons%% }

            segments+=(" $git_branch $git_status_icons")
            bgs+=("$SEGMENT_GIT_DIRTY_BG")
            fgs+=("$SEGMENT_GIT_DIRTY_FG")
            bg_color_names+=("$C_GIT_DIRTY_BG_NAME")
        else
            # Clean repo
            segments+=(" $git_branch $GIT_ICON_CLEAN")
            bgs+=("$SEGMENT_GIT_BG")
            fgs+=("$SEGMENT_GIT_FG")
            bg_color_names+=("$C_GIT_BG_NAME")
        fi
        last_segment_is_git=true
    fi

    # Exit code
    if [[ $EXIT_CODE -ne 0 ]]; then
        local error_reason=$(get_error_reason $EXIT_CODE)
        segments+=("👻 $error_reason")
        bgs+=("$SEGMENT_EXIT_BG")
        fgs+=("$SEGMENT_EXIT_FG")
        bg_color_names+=("$C_EXIT_BG_NAME")
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
        prompt_line+="%{$fg[$last_bg_name]%}%k$SEPARATOR%{$reset_color%}"
    fi

    # Set the prompt
    PS1="$prompt_line
❯ "
}

# Enable the prompt function - this is the only execution that should happen
autoload -Uz add-zsh-hook
add-zsh-hook precmd build_prompt 