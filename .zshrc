bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# Git
source /usr/share/zsh/completions/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
setopt PROMPT_SUBST ; PS1='%F{2}%n@%m%f:%F{6}%c%f%F{1}$(__git_ps1 " (%s)")%f\$ '

function wincmd()
{
    CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f CP932 -t UTF-8
}
alias cmd='winpty cmd'
alias psh='winpty powershell'
alias ipconfig='wincmd ipconfig'
alias netstat='wincmd netstat'
alias netsh='wincmd netsh'
alias ping='wincmd /c/windows/system32/ping'

alias ls='ls --color=auto --show-control-chars --time-style=long-iso --human-readable --classify'
export MANPATH=$MANPATH:/usr/local/texlive/2019/texmf-dist/doc/man:/c/PROGRA~2/Graphviz2.38/share/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2019/texmf-dist/doc/info
export PATH=$PATH:/usr/local/texlive/2019/bin/win32:/c/PROGRA~2/Graphviz2.38/bin
