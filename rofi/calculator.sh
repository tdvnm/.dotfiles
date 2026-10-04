#!/usr/bin/env bash
# rofi calculator. type an expression, get the result, it stays on screen so
# you can keep going. the answer is copied to the clipboard each time.

result=""
prompt="calc:"

while true; do
    if [ -n "$result" ]; then
        expr=$(echo "$result" | rofi -dmenu -p "$prompt" -theme ~/.config/rofi/theme.rasi)
    else
        expr=$(rofi -dmenu -p "$prompt" -theme ~/.config/rofi/theme.rasi)
    fi

    [ -z "$expr" ] && exit 0

    # evaluate math only. a whitelisted ast walker — no eval(), so pasting
    # something like  __import__('os').system('...')  can't run anything.
    result=$(printf '%s' "$expr" | python3 -c '
import ast, operator, math, sys

ops = {
    ast.Add: operator.add, ast.Sub: operator.sub, ast.Mult: operator.mul,
    ast.Div: operator.truediv, ast.FloorDiv: operator.floordiv,
    ast.Mod: operator.mod, ast.Pow: operator.pow,
    ast.USub: operator.neg, ast.UAdd: operator.pos,
}
# every non-underscore name from math: sin, pi, sqrt, log, ...
names = {k: v for k, v in vars(math).items() if not k.startswith("_")}

def ev(node):
    if isinstance(node, ast.Expression):
        return ev(node.body)
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        return node.value
    if isinstance(node, ast.BinOp) and type(node.op) in ops:
        return ops[type(node.op)](ev(node.left), ev(node.right))
    if isinstance(node, ast.UnaryOp) and type(node.op) in ops:
        return ops[type(node.op)](ev(node.operand))
    if isinstance(node, ast.Name) and node.id in names:
        return names[node.id]
    if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) \
            and node.func.id in names and not node.keywords:
        return names[node.func.id](*[ev(a) for a in node.args])
    raise ValueError("not allowed")

try:
    print(ev(ast.parse(sys.stdin.read(), mode="eval")))
except Exception as e:
    print(f"error: {e}")
')

    printf '%s' "$result" | wl-copy
    notify-send "= $result" "$expr"
    prompt="$result ="
done
