import os
import subprocess
import sys
from abc import ABC, abstractmethod
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Callable

from kitty.fast_data_types import (
    Screen,
    get_boss,
    get_options,
)
from kitty.fast_data_types import (
    add_timer as kitty_add_timer,
)
from kitty.tab_bar import DrawData, ExtraData, TabAccessor, TabBarData, as_rgb
from kitty.utils import color_as_int

REFRESH_BATTERY_TIME = 15

SEPARATOR: str = "│"

APP_ICONS: dict[str, str] = {
    "alacritty": "",
    "ansible": "",
    "ant": "",
    "apache2": "",
    "apt": "",
    "atom": "",
    "aws": "",
    "babel": "",
    "bash": "",
    "beam.smp": "",
    "bitbucket": "",
    "brew": "",
    "btop": "",
    "caffeinate": "",
    "cargo": "",
    "cfdisk": "",
    "clang": "",
    "clion": "",
    "cmake": "",
    "code": "",
    "code-insiders": "",
    "composer": "",
    "crontab": "",
    "csharp": "",
    "curl": "",
    "dart": "",
    "deno": "",
    "dnf": "",
    "docker": "",
    "doctl": "",
    "dotnet": "",
    "dpkg": "",
    "eclipse": "",
    "elixir": "",
    "emacs": "",
    "fdisk": "",
    "firebase": "",
    "fish": "",
    "flutter": "",
    "gcc": "",
    "gcloud": "",
    "gdb": "",
    "gh": "",
    "ghc": "",
    "ghostty": "",
    "git": "",
    "gitlab": "",
    "gitui": "",
    "gnome-terminal": "",
    "go": "",
    "gpg": "",
    "gradle": "",
    "grunt": "",
    "gulp": "",
    "helm": "󱃾",
    "heroku": "",
    "hg": "",
    "htop": "",
    "httpd": "",
    "hx": "󰔤",
    "idea": "",
    "iterm2": "",
    "java": "",
    "jekyll": "",
    "jenkins": "",
    "jest": "",
    "julia": "",
    "just": "",
    "k9s": "󱃾",
    "kubectl": "󱃾",
    "laravel": "",
    "lazydocker": "",
    "lazygit": "",
    "lf": "",
    "lfcd": "",
    "lldb": "",
    "lua": "",
    "lvim": "",
    "mactop": "",
    "make": "",
    "maven": "",
    "minikube": "󱃾",
    "mocha": "",
    "mongo": "",
    "mysql": "",
    "nala": "",
    "nano": "",
    "netbeans": "",
    "ng": "",
    "nginx": "",
    "node": "",
    "npm": "",
    "nu": "",
    "nvim": "",
    "openssl": "",
    "pacman": "",
    "parted": "",
    "paru": "",
    "perl": "",
    "php": "",
    "pip": "",
    "pip3": "",
    "powershell": "",
    "psql": "",
    "puppet": "",
    "pycharm": "",
    "python": "",
    "python3": "",
    "r": "ﳒ",
    "ranger": "",
    "react": "",
    "redis": "",
    "rsync": "",
    "ruby": "",
    "rustc": "",
    "rustup": "",
    "scala": "",
    "scp": "󰣀",
    "screen": "",
    "sqlite": "",
    "ssh": "󰣀",
    "stack": "",
    "sublime_text": "",
    "sudo": "",
    "svn": "",
    "swift": "",
    "systemctl": "",
    "tcsh": "",
    "terraform": "ﲽ",
    "tig": "",
    "tmux": "",
    "top": "",
    "topgrade": "󰚰",
    "travis": "",
    "tsc": "",
    "unzip": "",
    "vagrant": "",
    "valgrind": "",
    "vi": "",
    "vim": "",
    "virtualbox": "",
    "visualstudio": "",
    "vue": "﵂",
    "webpack": "",
    "weechat": "󰭹",
    "wget": "",
    "wordpress": "",
    "yarn": "",
    "yay": "",
    "yazi": "󰇥",
    "yum": "",
    "zip": "",
    "zsh": "",
}


def get_log_file() -> Path:
    xdg_state_home = os.getenv("XDG_STATE_HOME", Path.home() / ".local" / "state")

    log_file = Path(xdg_state_home) / "kitty" / "tab_bar.log"
    log_file.parent.mkdir(parents=True, exist_ok=True)

    return log_file


log_file = get_log_file()

opts = get_options()
battery: int | None = None


def get_app_icon(exe: str) -> str:
    return APP_ICONS.get(exe, "")


def hex_to_rgb(hex_color: str) -> int:
    return as_rgb(int(hex_color.lstrip("#"), 16))


@dataclass(frozen=True)
class TabBarColors:
    # Base colors
    red: int = hex_to_rgb("#db4b4c")
    green: int = hex_to_rgb("#44ffb1")
    yellow: int = hex_to_rgb("#ffe073")
    blue: int = hex_to_rgb("#0fc5ed")
    pink: int = hex_to_rgb("#ffb3c6")
    teal: int = hex_to_rgb("#24eaf7")
    sapphire: int = hex_to_rgb("#19bfe2")
    sky: int = hex_to_rgb("#3fd9f2")
    mauve: int = hex_to_rgb("#a277ff")

    # Variants / softer tints
    rosewater: int = hex_to_rgb("#ffdfa3")
    flamingo: int = hex_to_rgb("#ff8fa1")
    maroon: int = hex_to_rgb("#d65c6c")
    peach: int = hex_to_rgb("#ffb86c")

    # Text and overlays
    thm_text: int = hex_to_rgb("#e6eaf2")
    thm_subtext1: int = hex_to_rgb("#c0a6ff")
    thm_subtext0: int = hex_to_rgb("#7ccbe6")
    thm_overlay2: int = hex_to_rgb("#6be1bf")
    thm_overlay1: int = hex_to_rgb("#5bc9e0")
    thm_overlay0: int = hex_to_rgb("#3a607a")

    # Surfaces / base shades
    surface2: int = hex_to_rgb("#2c4f66")
    surface1: int = hex_to_rgb("#28465c")
    surface0: int = hex_to_rgb("#243c52")
    base: int = hex_to_rgb("#214969")
    mantle: int = hex_to_rgb("#1d3f59")
    crust: int = hex_to_rgb("#192f40")

    # Lavender
    lavender: int = hex_to_rgb("#c5a3ff")


colors = TabBarColors()
foreground = as_rgb(color_as_int(opts.foreground))
background = as_rgb(color_as_int(opts.background))


@dataclass
class CellData:
    content: str
    fg: int
    bg: int
    bold: bool = False
    borders: tuple[str, str] | None = None
    padding: int = 1

    @property
    def length(self) -> int:
        padding_length = self.padding * 2
        borders_length = len(self.borders[0] + self.borders[1]) if self.borders else 0
        return len(self.content) + padding_length + borders_length


class Cell(ABC):
    def __init__(self):
        self.data: CellData | None = None

    @property
    @abstractmethod
    def length(self) -> int: ...

    @abstractmethod
    def update(self, max_size: int) -> None: ...

    @abstractmethod
    def draw(self, screen: Screen) -> None: ...

    def update_and_draw(self, screen: Screen, max_size: int) -> None:
        self.update(max_size)
        self.draw(screen)


class InfoCell(Cell):
    def __init__(
        self,
        update_fn: Callable[[int], CellData | None],
    ) -> None:
        self.update_fn: Callable[[int], CellData | None] = update_fn

    @property
    def length(self) -> int:
        if self.data is None:
            return 0
        padding_length = self.data.padding * 2
        borders_length = (
            len(self.data.borders[0] + self.data.borders[1]) if self.data.borders else 0
        )
        return len(self.data.content) + padding_length + borders_length

    def update(self, max_size: int) -> None:
        self.data = self.update_fn(max_size)

    def draw(self, screen: Screen) -> None:
        if self.data is None:
            return

        padding = " " * self.data.padding

        cursor = screen.cursor

        cursor.bold = False
        cursor.italic = False

        if self.data.borders is not None:
            cursor.fg = self.data.bg
            cursor.bg = background
            screen.draw(self.data.borders[0])

        cursor.fg = self.data.fg
        cursor.bg = self.data.bg
        cursor.bold = self.data.bold
        screen.draw(f"{padding}{self.data.content}{padding}")

        if self.data.borders is not None:
            cursor.fg = self.data.bg
            cursor.bg = background
            screen.draw(self.data.borders[1])


class TabCell(Cell):
    def __init__(
        self,
        update_fn: Callable[[int, TabBarData], CellData | None],
        tab: TabBarData | None = None,
    ) -> None:
        self.update_fn: Callable[[int, TabBarData], CellData | None] = update_fn
        self.tab: TabBarData | None = tab

    @property
    def length(self) -> int:
        if self.data is None:
            return 0
        padding_length = self.data.padding * 2
        borders_length = (
            len(self.data.borders[0] + self.data.borders[1]) if self.data.borders else 0
        )
        return len(self.data.content) + padding_length + borders_length

    def update(self, max_size: int) -> None:
        if self.tab is not None:
            self.data = self.update_fn(max_size, self.tab)

    def draw(self, screen: Screen) -> None:
        if self.data is None:
            return

        padding = " " * self.data.padding

        cursor = screen.cursor

        cursor.bold = False
        cursor.italic = False

        if self.data.borders is not None:
            cursor.fg = self.data.bg
            cursor.bg = background
            screen.draw(self.data.borders[0])

        cursor.fg = self.data.fg
        cursor.bg = self.data.bg
        cursor.bold = self.data.bold
        screen.draw(f"{padding}{self.data.content}{padding}")

        if self.data.borders is not None:
            cursor.fg = self.data.bg
            cursor.bg = background
            screen.draw(self.data.borders[1])


def get_session_cell() -> InfoCell:
    def get_session(max_size: int) -> CellData | None:
        boss = get_boss()
        active_tab = boss.active_tab
        if active_tab is None:
            return None

        session_name = active_tab.active_session_name

        if session_name == "":
            return None

        content = f" {session_name}"

        active_window = boss.active_window

        is_prefix_active = (
            active_window.user_vars.get("KITTY_PREFIX_ACTIVE", "0") == "1"
            if active_window is not None
            else False
        )

        if is_prefix_active:
            return CellData(content=content, fg=foreground, bg=colors.red, bold=True)
        return CellData(content=content, fg=colors.red, bg=background, bold=True)

    return InfoCell(update_fn=get_session)


def get_application_cell() -> InfoCell:
    def get_application(max_size: int) -> CellData | None:
        boss = get_boss()
        if boss.active_tab is None:
            return None

        active_tab = TabAccessor(boss.active_tab.id)
        title = active_tab.active_oldest_exe.lstrip("-")
        content = f" {title}"
        return CellData(content=content, fg=colors.green, bg=background, bold=True)

    return InfoCell(update_fn=get_application)


def get_cwd_cell() -> InfoCell:
    def get_cwd(max_size: int) -> CellData | None:
        boss = get_boss()
        if boss.active_tab is None:
            return None

        active_tab = TabAccessor(boss.active_tab.id)

        active_oldest_wd = active_tab.active_oldest_wd
        if active_oldest_wd == "":
            return None

        wd = Path(active_oldest_wd)

        home_env = os.getenv("HOME")
        if home_env is not None:
            home = Path(home_env)

            if wd.is_relative_to(home):
                wd = wd.relative_to(home)

                if wd == home:
                    wd = Path("~")
                else:
                    wd = Path("~") / wd

        content = f" {wd.name}"
        return CellData(content=content, fg=colors.blue, bg=background, bold=True)

    return InfoCell(update_fn=get_cwd)


def get_layout_cell() -> InfoCell:
    def get_layout(max_size: int) -> CellData | None:
        active_tab = get_boss().active_tab
        if active_tab is None:
            return None

        is_maximized = active_tab.current_layout.name == "stack"

        if not is_maximized:
            return None

        return CellData(content=" zoom", fg=colors.yellow, bg=background, bold=True)

    return InfoCell(update_fn=get_layout)


def get_battery_cell() -> InfoCell:
    def get_battery(max_size: int) -> CellData | None:
        if battery is None:
            return None
        if battery > 20:
            fg = colors.green
            bg = background
        else:
            fg = foreground
            bg = colors.red
        content = f"󱐋 {battery}%"
        return CellData(content=content, fg=fg, bg=bg, bold=True)

    return InfoCell(update_fn=get_battery)


def get_time_cell() -> InfoCell:
    def get_time(max_size: int) -> CellData | None:
        content = datetime.now().strftime("󰭦 %Y-%m-%d  %H:%M")
        return CellData(content=content, fg=colors.teal, bg=background, bold=True)

    return InfoCell(update_fn=get_time)


def get_tab_cell(tab: TabBarData, index: int) -> TabCell:
    def get_tab(max_size: int, tab: TabBarData) -> CellData | None:
        accessor = TabAccessor(tab.tab_id)

        exe = accessor.active_oldest_exe.lstrip("-")
        icon = get_app_icon(exe)
        content = f"{str(index)} {icon}"

        if tab.is_active:
            fg = colors.blue
            bold = True
        else:
            fg = colors.mauve
            bold = False

        return CellData(content=content, fg=fg, bg=background, bold=bold)

    return TabCell(update_fn=get_tab, tab=tab)


def draw_separator(
    screen: Screen, *, fg: int = foreground, bg: int = background
) -> None:
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.draw(SEPARATOR)


class TabBar:
    def __init__(self) -> None:
        self.left_max: int = 100
        self.right_max: int = 100

        self.left_cells: list[Cell] = [
            get_session_cell(),
            get_application_cell(),
            get_cwd_cell(),
        ]
        self.right_cells: list[Cell] = [
            get_layout_cell(),
            get_battery_cell(),
            get_time_cell(),
        ]
        self.center_cells: list[Cell] = []

    def update_left(self) -> None:
        for cell in self.left_cells:
            cell.update(self.left_max)

    def update_right(self) -> None:
        for cell in self.right_cells:
            cell.update(self.right_max)

    def update_center(self, screen: Screen) -> None:
        left_length = sum(cell.length for cell in self.left_cells)
        right_length = sum(cell.length for cell in self.right_cells)
        max_length = screen.columns - left_length - right_length

        for cell in self.center_cells:
            cell.update(max_length)

    def draw_left(self, screen: Screen) -> None:
        cells_with_data = [cell for cell in self.left_cells if cell.data is not None]

        screen.cursor.x = 0
        for i, cell in enumerate(cells_with_data):
            cell.draw(screen)
            if i < len(cells_with_data) - 1:
                draw_separator(screen, fg=colors.thm_overlay0)

    def draw_right(self, screen: Screen) -> None:
        right_length = sum(cell.length for cell in self.right_cells)
        cells_with_data = [cell for cell in self.right_cells if cell.data is not None]

        screen.cursor.x = (
            screen.columns
            - right_length
            - (len(SEPARATOR) * (len(cells_with_data) - 1))
        )
        for i, cell in enumerate(cells_with_data):
            cell.draw(screen)
            if i < len(cells_with_data) - 1:
                draw_separator(screen, fg=colors.thm_overlay0)

    def draw_center(self, screen: Screen) -> None:
        center_length = sum(cell.length for cell in self.center_cells)
        cells_with_data = [cell for cell in self.center_cells if cell.data is not None]

        start_pos = (screen.columns - center_length) // 2

        screen.cursor.x = start_pos
        for cell in cells_with_data:
            cell.draw(screen)

    def draw_tab(
        self,
        draw_data: DrawData,
        screen: Screen,
        tab: TabBarData,
        before: int,
        max_title_length: int,
        index: int,
        is_last: bool,
        extra_data: ExtraData,
    ) -> int:
        index = len(self.center_cells) + 1
        self.center_cells.append(get_tab_cell(tab, index))

        if is_last:
            self.update_left()
            self.update_right()
            # We must update left and right cells before center cells, as
            # center cell updates rely on the length of left and right cells to
            # calculate the available space for center cells
            self.update_center(screen)

            self.draw_left(screen)
            self.draw_center(screen)
            self.draw_right(screen)

            # Clear center cells after drawing to prepare for the next draw
            # cycle
            self.center_cells = []

        # We return 0 here for every tab to effectively disable clicking on
        # tabs, as there is no way to assign the click rect to the correct
        # tabs without knowing the length of the center section beforehand
        return 0


bar = TabBar()


def add_timer(
    callback: Callable[[int | None], None],
    interval: int | float,
    repeats: bool = False,
    run_immediately: bool = False,
) -> int:
    if run_immediately:
        callback(None)
    return kitty_add_timer(callback, interval, repeats)


def update_battery(_) -> None:
    global battery

    try:
        platform = sys.platform.lower()
        if platform == "darwin":
            output = subprocess.getoutput("pmset -g batt | grep -o '[0-9]\\{1,3\\}%'")
            if output:
                battery = int(output.strip().rstrip("%"))
    except Exception:
        battery = None


add_timer(update_battery, REFRESH_BATTERY_TIME, True, True)


def draw_tab(*args) -> int:
    return bar.draw_tab(*args)
