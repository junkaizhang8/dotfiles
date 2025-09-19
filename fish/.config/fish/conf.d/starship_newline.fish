set -g PROMPT_NEEDS_NEWLINE 0

function _newline_precmd --on-event fish_prompt
    if test $PROMPT_NEEDS_NEWLINE -eq 1
        echo ""
    end
    set -g PROMPT_NEEDS_NEWLINE 1
end

function clear
    set -g PROMPT_NEEDS_NEWLINE 0
    command clear
end

function fish_prompt
    starship prompt
end
