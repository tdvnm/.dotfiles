#!/usr/bin/env python3
"""
Toggle a dedicated dropdown terminal, bound to the Copilot key.

First press spawns kitty under the app_id "scratchterm"; the matching
for_window rule in config drops it into the scratchpad and shows it centred.
Every press after that toggles the same window in and out of view, so the
terminal keeps its shell history and running jobs between presses.

Targeting the window by criteria means this never disturbs whatever else is
sitting in the scratchpad ring on $mod+minus.
"""
import json, os, pwd, subprocess

SWAYMSG = '/run/current-system/sw/bin/swaymsg'
APP_ID  = 'scratchterm'

def exists(node):
    """True if a window with our app_id is anywhere in the tree.

    Recurses through floating_nodes too — a window parked in the scratchpad
    lives as a floating child of the hidden __i3_scratch workspace.
    """
    if node.get('app_id') == APP_ID:
        return True
    return any(exists(child) for child in
               node.get('nodes', []) + node.get('floating_nodes', []))

def starting():
    """True if a scratchterm kitty is already launching but hasn't mapped yet.

    kitty takes a second or two to show a window on a cold start, and the
    copilot key is easy to tap twice in that gap — without this check the
    second press sees no window, spawns a duplicate, and the two then toggle
    each other. Matching on argv[0] avoids matching shell wrappers.
    """
    for pid in os.listdir('/proc'):
        if not pid.isdigit():
            continue
        try:
            with open(f'/proc/{pid}/cmdline', 'rb') as f:
                argv = f.read().split(b'\0')
        except OSError:
            continue          # process exited, or not ours to read
        if argv and argv[0].endswith(b'kitty') and APP_ID.encode() in argv:
            return True
    return False

tree = json.loads(subprocess.check_output([SWAYMSG, '-t', 'get_tree']))

if exists(tree):
    # sway toggles: shows it if hidden, sends it back to the scratchpad if visible
    subprocess.run([SWAYMSG, f'[app_id="{APP_ID}"] scratchpad show'],
                   capture_output=True)
elif not starting():
    # kitty prefers $SHELL over the passwd entry, and $SHELL is whatever the
    # launching environment happened to export. Read the login shell straight
    # from passwd so this always matches users.users.toad.shell.
    shell = pwd.getpwuid(os.getuid()).pw_shell
    os.execvp('kitty', ['kitty', '--class', APP_ID, shell])
