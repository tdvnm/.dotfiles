#!/usr/bin/env python3
"""master-stack terminal opener for sway:
  1 window  -> fills the screen (master)
  2 windows -> master left | stack right
  3+        -> master left | stack stacked on the right
"""
import json, os, subprocess

SWAYMSG = "/run/current-system/sw/bin/swaymsg"

def sway(*args):
    subprocess.run([SWAYMSG, *args], capture_output=True)

def query(kind):
    return json.loads(subprocess.check_output([SWAYMSG, "-t", kind]))

def leaves(node):
    """tiling leaf windows under a node (excludes floating)."""
    if node.get("type") == "con" and not node.get("nodes"):
        return [node]
    return [w for c in node.get("nodes", []) for w in leaves(c)]

def find(node, pred):
    if pred(node):
        return node
    for c in node.get("nodes", []) + node.get("floating_nodes", []):
        if hit := find(c, pred):
            return hit
    return None

tree = query("get_tree")
name = next(w["name"] for w in query("get_workspaces") if w["focused"])
ws   = find(tree, lambda n: n.get("type") == "workspace" and n.get("name") == name)
wins = leaves(ws) if ws else []

if len(wins) == 1:
    # split the master so the next window opens to its right
    sway("split", "horizontal")
elif len(wins) >= 2:
    # jump off the master onto the stack side before opening
    focused = find(tree, lambda n: n.get("focused") and not n.get("nodes"))
    master_x = min(w["rect"]["x"] for w in wins)
    if focused and focused["rect"]["x"] == master_x:
        sway("focus", "right")
    if len(wins) == 2:            # wrap the lone stack window vertically
        sway("split", "vertical")

os.execvp("kitty", ["kitty"])
