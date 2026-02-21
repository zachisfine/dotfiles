# fish_prompt.fish — Two-line prompt for fish shell
# ┌─[zach@host]─[🐍 venv]─[⭐ main *+]─[~/projects/myapp]─[✘ 130]
# └─❯

function fish_prompt
    set -l last_status $status

    # Colors
    set -l c_reset   (set_color normal)
    set -l c_line    (set_color brblack)
    set -l c_bracket (set_color white)
    set -l c_user    (set_color -o cyan)
    set -l c_host    (set_color -o cyan)
    set -l c_dir     (set_color -o blue)
    set -l c_git     (set_color -o yellow)
    set -l c_venv    (set_color -o green)
    set -l c_err     (set_color -o red)
    set -l c_ok      (set_color -o green)

    # Line 1
    set -l line1 ""

    # Connector
    set line1 $line1$c_line"┌─"$c_reset

    # User@Host
    set line1 $line1$c_bracket"["$c_user(whoami)$c_reset"@"$c_host(hostname -s)$c_bracket"]"$c_line"─"$c_reset

    # Virtualenv
    if set -q VIRTUAL_ENV
        set -l venv_name (basename $VIRTUAL_ENV)
        set line1 $line1$c_bracket"["$c_venv"🐍 $venv_name"$c_bracket"]"$c_line"─"$c_reset
    end

    # Conda
    if set -q CONDA_DEFAULT_ENV; and test "$CONDA_DEFAULT_ENV" != "base"
        set line1 $line1$c_bracket"["$c_venv"🐍 $CONDA_DEFAULT_ENV"$c_bracket"]"$c_line"─"$c_reset
    end

    # Git
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git describe --tags --exact-match 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)

        set -l flags ""
        set -l gs (git status --porcelain 2>/dev/null)

        if echo "$gs" | grep -q '^.[MD]'
            set flags $flags"*"
        end
        if echo "$gs" | grep -q '^[MADRC]'
            set flags $flags"+"
        end
        if echo "$gs" | grep -q '^\?\?'
            set flags $flags"?"
        end
        if git stash list 2>/dev/null | grep -q .
            set flags $flags'$'
        end

        set -l git_display "⭐ $branch"
        if test -n "$flags"
            set git_display "$git_display $flags"
        end

        set line1 $line1$c_bracket"["$c_git$git_display$c_bracket"]"$c_line"─"$c_reset
    end

    # Directory
    set line1 $line1$c_bracket"["$c_dir(prompt_pwd)$c_bracket"]"$c_reset

    # Error segment
    if test $last_status -ne 0
        set line1 $line1$c_line"─"$c_bracket"["$c_err"✘ $last_status"$c_bracket"]"$c_reset
    end

    # Print line 1
    printf '%s\n' $line1

    # Line 2
    if test $last_status -eq 0
        printf '%s└─%s❯%s ' $c_line $c_ok $c_reset
    else
        printf '%s└─%s❯%s ' $c_line $c_err $c_reset
    end
end
