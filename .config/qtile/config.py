# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook, group
import os
import subprocess


try:
    from typing import List  # noqa: F401
except ImportError:
    pass


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])


def focus_to_next_screen(qtile):
    other_scr_index = (qtile.screens.index(qtile.currentScreen) + 1) % len(
        qtile.screens
    )
    qtile.toScreen(other_scr_index)


def kick_to_next_screen(qtile, direction=1):
    other_scr_index = (qtile.screens.index(qtile.currentScreen) + direction) % len(
        qtile.screens
    )
    othergroup = None
    for group in qtile.cmd_groups().values():
        if group["screen"] == other_scr_index:
            othergroup = group["name"]
            break
    if othergroup:
        qtile.moveToGroup(othergroup)


mod = "mod4"
alt = "mod1"
ctrl = "control"

keys = [
    # Key([mod], "j", lazy.layout.down()),
    # Key([mod], "k", lazy.layout.up()),
    # Key([mod], "h", lazy.layout.left()),
    # Key([mod], "l", lazy.layout.right()),
    # Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    # Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    # Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    # Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    # Key([mod, "control"], "j", lazy.layout.grow_down()),
    # Key([mod, "control"], "k", lazy.layout.grow_up()),
    # Key([mod, "control"], "h", lazy.layout.grow_left()),
    # Key([mod, "control"], "l", lazy.layout.grow_right()),
    # Key([mod], "Return", lazy.layout.toggle_split()),
    # Key([mod], "n", lazy.layout.normalize()),
    Key([ctrl, alt], "r", lazy.spawncmd()),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    # Switch between windows in current stack pane
    Key([ctrl, mod], "Down", lazy.layout.down()),
    Key([ctrl, mod], "Up", lazy.layout.up()),
    Key([ctrl, mod], "Left", lazy.layout.left()),
    Key([ctrl, mod], "Right", lazy.layout.right()),
    # Move windows up or down in current stack
    Key([mod], "Down", lazy.layout.shuffle_down()),
    Key([mod], "Up", lazy.layout.shuffle_up()),
    Key([mod], "Left", lazy.layout.shuffle_left()),
    Key([mod], "Right", lazy.layout.shuffle_right()),
    Key([mod, alt], "Down", lazy.layout.grow_down()),
    Key([mod, alt], "Up", lazy.layout.grow_up()),
    Key([mod, alt], "Left", lazy.layout.grow_left()),
    Key([mod, alt], "Right", lazy.layout.grow_right()),
    Key([ctrl, alt], "Left", lazy.screen.prev_group()),
    Key([ctrl, alt], "Right", lazy.screen.next_group()),
    Key([mod], "o", lazy.function(kick_to_next_screen)),
    # Key([mod, "shift"], "o", lazy.function(kick_to_next_screen, -1)),
    Key([ctrl, mod], "o", lazy.function(focus_to_next_screen)),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([ctrl, alt], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("xterm")),
    Key([ctrl, alt], "a", lazy.spawn("gnome-terminal")),
    Key([ctrl, alt], "s", lazy.spawn("gnome-terminal -- sudo su -")),
    Key(
        [ctrl, alt], "d", lazy.spawn("gnome-terminal -- /home/jof/bin/ssh-jof.guru.sh"),
    ),
    Key([ctrl, alt], "f", lazy.spawn("/home/jof/bin/purposeTerm.sh")),
    Key([ctrl, alt], "m", lazy.spawn("firefox -p default-release")),
    Key([], "XF86AudioPlay", lazy.spawn("sp play")),
    Key([], "XF86AudioPrev", lazy.spawn("sp prev")),
    Key([], "XF86AudioNext", lazy.spawn("sp next")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 -q set Master 2dB+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 -q set Master 2dB-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -c 0 -q set Master toggle")),
    Key([], "XF86Mail", lazy.spawn("/home/jof/bin/disable-keyboard.sh")),
    Key([], "XF86Explorer", lazy.spawn("killall evtest")),
    Key([ctrl], "XF86AudioRaiseVolume", lazy.spawn("setbacklight.sh +0.1")),
    Key([ctrl], "XF86AudioLowerVolume", lazy.spawn("setbacklight.sh -0.1")),
    Key(
        [ctrl, alt],
        "1",
        lazy.spawn(
            "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout uint32:0"
        ),
    ),
    Key(
        [ctrl, alt],
        "2",
        lazy.spawn(
            "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout uint32:1"
        ),
    ),
]


def show_shortcuts():
    key_map = {"mod1": "alt", "mod4": "super"}
    shortcuts_path = "{0}/{1}".format(os.environ["HOME"], "qtile_shortcuts")
    shortcuts = open("{0}".format(shortcuts_path), "w")
    shortcuts.write("{0:30}| {1:50}\n".format("KEYS COMBINATION", "COMMAND"))
    shortcuts.write("{0:80}\n".format("=" * 80))
    for key in keys:
        key_comb = ""
        for modifier in key.modifiers:
            key_comb += key_map.get(modifier, modifier) + "+"
        key_comb += key.key
        shortcuts.write("{0:30}| ".format(key_comb))
        cmd_str = ""
        for command in key.commands:
            cmd_str += command.name + " "
            for arg in command.args:
                cmd_str += "{0} ".format(repr(arg))
        shortcuts.write("{0:50}\n".format(cmd_str))
        shortcuts.write("{0:80}\n".format("-" * 80))
    shortcuts.close()
    return lazy.spawn("xterm -wf -e less {0}".format(shortcuts_path))


keys.append(Key([mod], "h", show_shortcuts()))

groups = [Group(i) for i in "1234567890qwertyuiop"]
for i in groups:
    # mod1 + letter of group = switch to group
    # keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name)))

groups.append(
    Group(
        "gimp",
        persist=False,
        init=False,  # layout='gimp',
        matches=[Match(wm_class=["Gimp"])],
    )
)

groups.append(
    Group(
        "Emulator",
        persist=False,
        init=False,
        matches=[Match(title=["Android Emulator - Nexus_5X_API_28:5554"])],
    )
)

layouts = [layout.Max(), layout.Columns(num_columns=2)]

widget_defaults = dict(font="sans", fontsize=12, padding=3,)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                # widget.KeyboardKbdd(configured_keyboards=['is', 'us']),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %H:%M"),
                widget.Volume(
                    theme_path="/usr/share/icons/AwOkenWhite/clear/24x24/status/"
                ),
            ],
            24,
        ),
    ),
    Screen(bottom=bar.Bar([widget.GroupBox(), widget.WindowName(),], 24,)),
    Screen(bottom=bar.Bar([widget.GroupBox(), widget.WindowName(),], 24,)),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "confirmreset"},  # gitk
        {"wmclass": "makebranch"},  # gitk
        {"wmclass": "maketag"},  # gitk
        {"wname": "branchdialog"},  # gitk
        {"wname": "pinentry"},  # GPG key password entry
        {"wmclass": "ssh-askpass"},  # ssh-askpass
        {"wmclass": "gimp"},
        {"wname": "Android Emulator - Nexus_5X_API_28:5554"},
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
