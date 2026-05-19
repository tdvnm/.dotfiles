#!/usr/bin/env python3
"""
DWM-style master-stack terminal opener for Sway.

Layout:
  1 window  → full screen (master)
  2 windows → left half (master) | right half (stack)
  3+windows → left half (master) | right half split vertically (stack)
"""
import json, os, subprocess, sys

def sway(*args):
    subprocess.run(['/run/current-system/sw/bin/swaymsg'] + list(args),
                   capture_output=True)

def get_tiling_leaves(node):
    """Recursively collect tiling leaf windows (excludes floating)."""
    if node.get('type') == 'con' and not node.get('nodes'):
        return [node]
    leaves = []
    for child in node.get('nodes', []):
        leaves.extend(get_tiling_leaves(child))
    return leaves

def find_workspace(node, name):
    if node.get('type') == 'workspace' and node.get('name') == name:
        return node
    for child in node.get('nodes', []):
        result = find_workspace(child, name)
        if result:
            return result
    return None

def find_focused_leaf(node):
    if node.get('focused') and node.get('type') == 'con' and not node.get('nodes'):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        result = find_focused_leaf(child)
        if result:
            return result
    return None

# --- gather info ---
workspaces = json.loads(subprocess.check_output(
    ['/run/current-system/sw/bin/swaymsg', '-t', 'get_workspaces']))
focused_name = next(w['name'] for w in workspaces if w['focused'])

tree = json.loads(subprocess.check_output(
    ['/run/current-system/sw/bin/swaymsg', '-t', 'get_tree']))

ws = find_workspace(tree, focused_name)
leaves = get_tiling_leaves(ws) if ws else []
count = len(leaves)

# --- decide layout action ---
if count == 0:
    # First window: just open it, fills the workspace
    pass

elif count == 1:
    # Second window: split master horizontally so it opens on the right
    sway('split', 'horizontal')

else:
    # 3+ windows: ensure focus is NOT on the master before opening
    focused = find_focused_leaf(tree)
    if focused and leaves:
        master_x = min(l['rect']['x'] for l in leaves)
        if focused['rect']['x'] == master_x:
            # Focused is master — move to stack side
            sway('focus', 'right')

    if count == 2:
        # Wrap the single stack window in a vertical container
        sway('split', 'vertical')
    # count >= 3: focus is already in the stack container, new window
    # opens as a vertical sibling automatically

os.execvp('kitty', ['kitty'])
