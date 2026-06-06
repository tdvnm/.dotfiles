function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)

    # [user@host]
    set_color normal
    printf '['
    set_color ff87af
    printf '%s' $USER
    set_color normal
    printf '@'
    set_color magenta
    printf '%s' (hostname -s)
    set_color normal
    printf ']'

    # (~/path/last)
    set_color normal
    printf '('
    # Split path: dim green for leading parts, bold green for last part
    set -l parts (string split '/' -- $cwd)
    if test (count $parts) -le 1
        set_color green --bold
        printf '%s' $cwd
    else
        set -l leading (string join '/' -- $parts[1..-2])
        set_color green
        printf '%s/' $leading
        set_color green --bold
        printf '%s' $parts[-1]
    end
    set_color normal
    printf ')'

    if test $last_status -ne 0
        set_color red
    else
        set_color normal
    end
    printf '> '
    set_color normal
end
