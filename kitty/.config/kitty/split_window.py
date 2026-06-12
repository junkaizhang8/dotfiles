from typing import Literal, cast

from kittens.tui.handler import result_handler
from kitty.boss import Boss
from kitty.key_encoding import KeyEvent, parse_shortcut

EdgeLiteral = Literal["left", "top", "right", "bottom"]


def main():
    pass


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def split_window(boss: Boss, direction: str):
    tab = boss.active_tab

    if tab is None:
        return

    # If we are currently in the 'stack' layout, we switch to the last used
    # layout before splitting
    if tab.current_layout.name == "stack":
        tab.last_used_layout()

    # Convert "up" and "down" to "top" and "bottom" for compatibility with
    # smart-splits.nvim's API which uses "up" and "down" but kitty uses
    # "top" and "bottom"
    if direction == "up":
        direction = "top"
    elif direction == "down":
        direction = "bottom"

    if direction == "top" or direction == "bottom":
        boss.launch("--cwd=current", "--location=hsplit")
    else:
        boss.launch("--cwd=current", "--location=vsplit")

    if direction == "top" or direction == "left":
        direction = cast(EdgeLiteral, direction)
        tab.move_window(direction)


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss):
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        return

    direction = args[1]
    cmd = window.child.foreground_cmdline[0]
    if cmd == "tmux":
        keymap = args[2]
        encoded = encode_key_mapping(window, keymap)
        window.write_to_child(encoded)
    else:
        split_window(boss, direction)
