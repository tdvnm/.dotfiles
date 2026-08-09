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
import json, os, subprocess

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

tree = json.loads(subprocess.check_output([SWAYMSG, '-t', 'get_tree']))

if exists(tree):
    # sway toggles: shows it if hidden, sends it back to the scratchpad if visible
    subprocess.run([SWAYMSG, f'[app_id="{APP_ID}"] scratchpad show'],
                   capture_output=True)
else:
    os.execvp('kitty', ['kitty', '--class', APP_ID])
