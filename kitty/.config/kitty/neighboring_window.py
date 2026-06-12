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


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss):
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    if cmd == "tmux":
        keymap = args[2]
        encoded = encode_key_mapping(window, keymap)
        window.write_to_child(encoded)
    else:
        tab = boss.active_tab

        if tab is None:
            return

        direction = args[1]

        # Convert "up" and "down" to "top" and "bottom" in case user uses
        # these instead of "top" and "bottom"
        if direction == "up":
            direction = "top"
        elif direction == "down":
            direction = "bottom"

        if direction not in ("left", "top", "right", "bottom"):
            return

        direction = cast(EdgeLiteral, direction)
        tab.neighboring_window(direction)
