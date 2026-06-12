"""
This kitten is a small modification of the `goto_session` command. It supports
most of the same arguments as `goto_session`, including no arguments and
session indices. It differs by disabling the ability to provide the path to a
directory to choose a session from. In return, it allows the user to provide
a session name to switch to, and it will look for a session file with that name
in the `~/.config/kitty/sessions` directory. Additionally, if the user tries
to switch to the session they are already in, it will toggle back to the
previous session, allowing for easy switching between two sessions.
"""

from pathlib import Path

from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main():
    pass


def resolve_session_path(session_name: str) -> Path:
    return (
        Path.home() / ".config" / "kitty" / "sessions" / f"{session_name}.kitty-session"
    )


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss):
    if len(args) < 2:
        return boss.goto_session()

    active_tab = boss.active_tab

    if active_tab is None:
        return

    session_name = args[1]

    if len(args) == 2:
        try:
            idx = int(session_name)
        except Exception:
            idx = 0
        if idx < 0:
            return boss.goto_session(session_name)

    resolved_path = resolve_session_path(session_name)

    # Check if session file exists
    if not resolved_path.is_file():
        boss.show_error("Invalid session", f"Session file not found: {resolved_path}")
        return

    current_session_name = active_tab.active_session_name

    # Acts as a toggle if the user tries to go to the session they are
    # already in
    if current_session_name == session_name:
        return boss.goto_session("-1")

    boss.goto_session(str(resolved_path))
