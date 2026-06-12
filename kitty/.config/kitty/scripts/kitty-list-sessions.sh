#!/usr/bin/env bash

# This is copied (and modified) from Linkarzu's dotfiles:
# https://github.com/linkarzu/dotfiles-latest/blob/main/kitty/scripts/kitty-list-sessions.sh
#
# Shows open kitty sessions in fzf and switches using goto_session
# Adds a vim-like "mode":
# - Normal mode (default): j/k move, d closes, enter opens, i enters insert mode, esc quits
# - Insert mode: type to filter, enter opens, esc returns to normal mode

set -euo pipefail

default_mode="insert"

set_cursor_block() {
  # DECSCUSR: steady block
  printf '\e[2 q' >/dev/tty
}

set_cursor_bar() {
  # DECSCUSR: steady bar
  printf '\e[6 q' >/dev/tty
}

# Always restore to bar on exit
trap 'set_cursor_bar' EXIT

kitty_bin="kitty"

hex_base="CBE0F0"
base_r=$((16#${hex_base:0:2}))
base_g=$((16#${hex_base:2:2}))
base_b=$((16#${hex_base:4:2}))
base_color="\033[38;2;${base_r};${base_g};${base_b}m"

hex_current="CBE0F0"
current_r=$((16#${hex_current:0:2}))
current_g=$((16#${hex_current:2:2}))
current_b=$((16#${hex_current:4:2}))
current_color="\033[38;2;${current_r};${current_g};${current_b}m"

reset_color="\033[0m"

fzf_colors="fg:#CBE0F0,bg:-1"
fzf_colors+=",fg+:#CBE0F0,bg+:#143652"
fzf_colors+=",hl:#B388FF,hl+:#B388FF"
fzf_colors+=",info:#0FC5ED"
fzf_colors+=",border:#24EAF7"
fzf_colors+=",prompt:#0FC5ED"
fzf_colors+=",pointer:#24EAF7"
fzf_colors+=",marker:#24EAF7"
fzf_colors+=",spinner:#24EAF7"
fzf_colors+=",header:#0FC5ED"
fzf_colors+=",label:#24EAF7"

# Requirements
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed or not in PATH."
  echo "Install (brew): brew install fzf"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is not installed or not in PATH."
  echo "Install (brew): brew install jq"
  exit 1
fi

if [[ -v KITTY_LISTEN_ON ]]; then
  sock="$KITTY_LISTEN_ON"
else
  echo "No kitty sockets found. Make sure remote control is enabled."
  exit 1
fi

build_menu_lines() {
  local sessions_tsv=""
  sessions_tsv="$(
    "$kitty_bin" @ --to "${sock}" ls 2>/dev/null | jq -r '
      [
        .[] as $os
        | $os.tabs[] as $tab
        | $tab.windows[]?
        | select(.session_name != null and .session_name != "")
          | {
              session_name: .session_name,
              pwd: (.env.PWD // .cwd),
              os_focused: ($os.is_focused // false),
              tab_focused: ($tab.is_focused // false),
              last_focused_at: (.last_focused_at // 0)
            }
        ]
      | sort_by(.session_name)
      | group_by(.session_name)
      | map({
          session_last_focused_at: (map(.last_focused_at) | max),
          pick: (
            if (map(.os_focused and .tab_focused) | any) then
              (map(select(.os_focused and .tab_focused)) | .[0])
            else
              .[0]
            end
          )
        })
      | map(.pick + {session_last_focused_at: .session_last_focused_at})
      | sort_by(-.session_last_focused_at, .session_name)
        | .[]
        | [(.session_name|tostring), (.os_focused|tostring), (.tab_focused|tostring), (.pwd|tostring)]
        | @tsv
    '
  )"

  if [[ -z "${sessions_tsv:-}" ]]; then
    return 1
  fi

  local icon="\033[34m\033[0m"

  # Process the TSV data in a single pass by storing rows in an internal array
  printf "%s\n" "$sessions_tsv" | awk -F'\t' -v home="${HOME}" -v base_color="${base_color}" -v current_color="${current_color}" -v reset_color="${reset_color}" -v icon="${icon}" '
    BEGIN {
      max_len = 0
      max_allowed_len = 25  # The alignment maximum length ceiling
    }
    {
      session_names[NR] = $1
      os_focused[NR]    = $2
      tab_focused[NR]   = $3
      paths[NR]         = $4
      
      # Track the maximum session name length dynamically
      len = length($1)
      if (len > max_len && len <= max_allowed_len) {
        max_len = len
      }
    }
    
    END {
      # Fallback defaults if no lines stay beneath the threshold limit ceiling
      if (max_len == 0) {
        max_len = max_allowed_len
      }
      
      for (i = 1; i <= NR; i++) {
        display_name = session_names[i]
        path         = paths[i]
        len          = length(display_name)
        
        if (path == home) {
          path = "~"
        } else if (index(path, home "/") == 1) {
          path = "~" substr(path, length(home) + 1)
        }
        
        if (os_focused[i] == "true" && tab_focused[i] == "true") {
          name_color = current_color
        } else {
          name_color = base_color
        }
        
        if (len <= max_allowed_len) {
          # Standard aligned row items
          printf "%d\t%s\t%s %s%-*s%s  %s\n", 
                 i, session_names[i], icon, name_color, max_len + 2, display_name, reset_color, path
        } else {
          # Outlier long item elements drop the padding spacing map to stop line-wrapping breakage
          printf "%d\t%s\t%s %s%s%s  %s\n", 
                 i, session_names[i], icon, name_color, display_name, reset_color, path
        }
      }
    }
  '
}

# Set the startup mode
mode="$default_mode"
fzf_start_pos=""

while true; do
  menu_lines="$(build_menu_lines || true)"
  if [[ -z "${menu_lines:-}" ]]; then
    echo "No sessions found."
    exit 1
  fi

  fzf_out=""
  fzf_rc=0

  if [[ "$mode" == "normal" ]]; then
    # Normal mode:
    # - Search disabled (typing doesn't filter)
    # - j/k move
    # - d closes session
    # - enter opens session
    # - i enters insert mode
    # - esc quits
    # - --no-clear avoids a visible screen "flash"
    #   - We exit one fzf instance and immediately start another when switching modes
    #   - Prevents fzf from clearing/restoring the screen on exit
    set_cursor_block
    set +e
    fzf_start_pos_opt=()
    if [[ -n "${fzf_start_pos:-}" && "$fzf_start_pos" -gt 1 ]]; then
      fzf_start_action="down"
      for ((i = 3; i <= fzf_start_pos; i++)); do
        fzf_start_action+="+down"
      done
      # Workaround for older fzf where start:* actions are ignored.
      # Based on https://github.com/junegunn/fzf/issues/4559
      fzf_start_pos_opt=(--bind "result:${fzf_start_action}")
    fi
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --ansi --margin=25%,25% --reverse \
          --border-label=" Sessions " \
          --header="Normal: j/k: move, d: close, enter: open, i: insert, esc: quit" \
          --prompt=" " \
          --no-multi --disabled \
          --with-nth=3.. \
          --expect=enter,d,i,esc \
          --bind 'j:down,k:up' \
          --bind 'enter:accept,d:accept,i:accept' \
          --bind 'esc:abort' \
          --no-clear \
          --color="$fzf_colors" \
          --border=rounded \
          ${fzf_start_pos_opt[@]+"${fzf_start_pos_opt[@]}"}

    )"
    fzf_rc=$?
    fzf_start_pos=""
    set -e
  else
    # Insert mode:
    # - Search enabled (type to filter)
    # - enter opens session
    # - esc returns to normal mode
    # - ctrl-c quits
    # - --no-clear avoids a visible screen "flash"
    #   - We exit one fzf instance and immediately start another when switching modes
    #   - Prevents fzf from clearing/restoring the screen on exit

    set_cursor_bar
    set +e
    fzf_out="$(
      printf "%s\n" "$menu_lines" |
        fzf --ansi --margin=25%,25% --reverse \
          --border-label=" Sessions " \
          --header="Insert: type to filter, enter: open, esc: normal, ctrl-c: quit" \
          --prompt=" " \
          --no-multi \
          --with-nth=3.. \
          --expect=enter,esc,ctrl-c \
          --bind 'enter:accept' \
          --bind 'esc:abort' \
          --no-clear \
          --border=rounded \
          --color="$fzf_colors"
    )"
    fzf_rc=$?
    set -e
  fi

  # If fzf aborted and gave no output, treat it like "esc"
  if [[ $fzf_rc -ne 0 && -z "${fzf_out:-}" ]]; then
    key="esc"
    sel=""
  else
    key="$(printf "%s\n" "$fzf_out" | head -n1)"
    sel="$(printf "%s\n" "$fzf_out" | sed -n '2p' || true)"
  fi

  if [[ "$key" == "ctrl-c" ]]; then
    exit 0
  fi

  # Selection line is: idx<TAB>session_name<TAB>pretty_display
  selected_title=""
  selected_index=""
  if [[ -n "${sel:-}" ]]; then
    selected_index="$(printf "%s" "$sel" | awk -F'\t' '{print $1}')"
    selected_title="$(printf "%s" "$sel" | awk -F'\t' '{print $2}')"
  fi

  if [[ "$mode" == "insert" && "$key" == "esc" ]]; then
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "esc" ]]; then
    exit 0
  fi

  if [[ "$mode" == "normal" && "$key" == "i" ]]; then
    mode="insert"
    continue
  fi

  if [[ -z "${selected_title:-}" ]]; then
    # Nothing selected (likely esc)
    if [[ "$mode" == "normal" ]]; then
      exit 0
    fi
    mode="normal"
    continue
  fi

  if [[ "$mode" == "normal" && "$key" == "d" ]]; then
    if [[ "${selected_index:-}" =~ ^[0-9]+$ ]]; then
      total_lines="$(printf "%s\n" "$menu_lines" | awk 'END{print NR}')"
      if [[ -n "${total_lines:-}" && "$selected_index" -ge "$total_lines" ]]; then
        fzf_start_pos=$((selected_index - 1))
      else
        fzf_start_pos=$selected_index
      fi
      if [[ "$fzf_start_pos" -lt 1 ]]; then
        fzf_start_pos=1
      fi
    fi
    "$kitty_bin" @ --to "${sock}" action close_session "$selected_title" >/dev/null 2>&1 || true
    continue
  fi

  if [[ "$key" == "enter" ]]; then
    "$kitty_bin" @ --to "${sock}" action goto_session "$selected_title"
    exit 0
  fi

  # Fallback behavior:
  # - In insert mode, abort returns here -> go back to normal
  # - In normal mode, unknown key -> exit
  if [[ "$mode" == "insert" ]]; then
    mode="normal"
    continue
  fi

  exit 0
done
