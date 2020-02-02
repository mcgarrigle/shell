
alias ll="ls -la"
alias vi="vim"
alias f="find . -name"

alias tm='tmux new-session \; split-window -h \; split-window -v \; attach'

export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export PS1='[\u@\h \W]\$ '

for app in git ruby vbx puppet docker terraform; do
  source "aliases-${app}.sh"
done

if [ -z "${proxy}" ]; then
  export proxy="http://127.0.0.1:9090"
fi

function p0 {
  unset http_proxy
  unset https_proxy
}

function p1 {
  export http_proxy=$proxy
  export https_proxy=$proxy
}

function contains {
  [ -z "${2##*$1*}" ]
}

OS=$(uname -s)

PLATFORM=$(echo "$OS" | awk '{print tolower($0)}')

if contains "mingw" "$PLATFORM"; then
  PLATFORM="mingw"
fi

source "bashrc-os-${PLATFORM}"

unset TMOUT

# ---------------------------------
# s - ssh matching name in 
#     inventory

function s {
  ssh -q "$(_inventory | grep -h -m 1 $1 | cut -d' ' -f1)"
}

# extract inventory file removing comment lines

function _inventory {
  sed '/^#/d' "$HOME/.inventory"
}

function _s_completions
{
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  if [ -z "$2" ]; then
    COMPREPLY=($(_inventory))
  else
    COMPREPLY=($(_inventory | grep -h $2 | cut -d' ' -f1))
  fi
}

complete -F _s_completions s
