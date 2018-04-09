# forked from Toaster https://github.com/oh-my-fish/theme-toaster

set __slavic_color_orange FD971F
set __slavic_color_blue 6EC9DD
set __slavic_color_green A6E22E
set __slavic_color_red E62622
set __slavic_color_yellow E6DB7E
set __slavic_color_pink F92672
set __slavic_color_grey 554F48
set __slavic_color_white F1F1F1
set __slavic_color_purple 9458FF
set __slavic_color_lilac AE81FF

set __slavic_tail_wave "彡ミ"
set __slavic_git_symbol " ☭ "
set __slavic_cat " (^._.^)ﾉ"
set __slavic_git_dirty " ●"
set __slavic_git_clean " ○"
set __slavic_prompt "⫸  "
set __slavic_attention_sign (printf "\u2622")

function __slavic_color_echo
  set_color $argv[1]
  if test (count $argv) -eq 2
    echo -n $argv[2]
  end
end

function __slavic_current_folder
  if test $PWD = '/'
    echo -n '/'
  else
    echo -n $PWD | grep -o -E '[^\/]+$'
  end
end

function __slavic_git_status_codes
  echo (git status --porcelain ^/dev/null | sed -E 's/(^.{3}).*/\1/' | tr -d ' \n')
end

function __slavic_git_branch_name
  echo (git rev-parse --abbrev-ref HEAD ^/dev/null)
end

function __slavic_rainbow
  if echo $argv[1] | grep -q -e $argv[3]
    __slavic_color_echo $argv[2] $__slavic_tail_wave 
  end
end

function __slavic_git_status_icons
  set -l git_status (__slavic_git_status_codes)

  __slavic_rainbow $git_status $__slavic_color_pink 'D' # deleted
  __slavic_rainbow $git_status $__slavic_color_orange 'R' # renamed
  __slavic_rainbow $git_status $__slavic_color_white 'C' # copied
  __slavic_rainbow $git_status $__slavic_color_green 'A' # added
  __slavic_rainbow $git_status $__slavic_color_blue 'U' # updated, not merged
  __slavic_rainbow $git_status $__slavic_color_lilac 'M' # modified
  __slavic_rainbow $git_status $__slavic_color_grey '?' # untracked
end

function __slavic_git_status
  # In git
  if test -n (__slavic_git_branch_name)

    __slavic_color_echo $__slavic_color_blue $__slavic_git_symbol 
    __slavic_color_echo $__slavic_color_white (__slavic_git_branch_name)

    if test -n (__slavic_git_status_codes)
      __slavic_color_echo $__slavic_color_pink $__slavic_git_dirty 
      __slavic_color_echo $__slavic_color_white $__slavic_cat 
      __slavic_git_status_icons
    else
      __slavic_color_echo $__slavic_color_green $__slavic_git_clean 
    end
  end
end

function __slavic_uname_host -d "Outputs the username and hostname if you're root or in a remote connection"
  if test (id -u) -eq 0 -o -n "$SSH_CONNECTION"
    if test (id -u) -eq 0
      echo -n (set_color -b $__slavic_color_red)
      __slavic_color_echo $__slavic_color_white $__slavic_attention_sign
    else
      __slavic_color_echo $__slavic_color_green
    end
    echo -n (whoami)"@"(hostname)
    __slavic_color_echo normal " "
  end
end

function fish_prompt
  set_color $__slavic_color_lilac
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    printf '['
    switch $fish_bind_mode
      case default
        set_color red
        printf $fish_bind_mode
      case insert
        set_color green
        printf 'i'
      case visual
        set_color magenta
        printf 'v'
    end
    set_color $__slavic_color_lilac
    printf '] '
  end
  __slavic_uname_host
  __slavic_color_echo $__slavic_color_purple (prompt_pwd)
  __slavic_git_status

  echo
  __slavic_color_echo $__slavic_color_pink $__slavic_prompt 
  __slavic_color_echo normal
end
