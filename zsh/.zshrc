# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

 # Path to your oh-my-zsh installation.
export ZSH=$HOME"/.oh-my-zsh"
ZSH_THEME=""
export EDITOR=nvim
fpath+=$HOME/.config/zsh/pure


# Prevents conflict between system and conda terminal info
export TERMINFO="/usr/share/terminfo"
export TERMINFO_DIRS="/usr/share/terminfo"

# miniconda3
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1


# yazi (file manager)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# CUDA
export PATH=/opt/cuda/bin:$PATH

#cudnn
export LD_LIBRARY_PATH=/usr/lib/cuda:$LD_LIBRARY_PATH

# Add CUDA libraries to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# fzf
source <(fzf --zsh)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="itchy"

# zstyle :prompt:pure:path color white

# FAV
# kolo itchy


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.


plugins=(git archlinux zsh-syntax-highlighting zsh-autosuggestions dotbare)
source $ZSH/oh-my-zsh.sh

# testing oxide vs autojump
eval "$(zoxide init zsh)"

autoload -U promptinit; promptinit
zstyle ':prompt:pure:prompt:*' color '#998a96'
prompt pure

# Latex to path
export PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"

## Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000
unsetopt autocd beep
bindkey -v

# Prompt zshell

# CHANGE CURSOR IN VI MODE

KEYTIMEOUT=5

function zle-keymap-select () {

case $KEYMAP in
  vicmd) echo -ne '\e[1 q';; # block

  viins|main) echo -ne '\e[5 q';; # beam
esac

}

zle -N zle-keymap-select

zle-line-init() {
zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
_fix_cursor(){
  echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursot)

# VI Mode in zsh copies to clipboard

# Copy CUTBUFFER to clipboard
function copy_to_clipboard() {
  if [[ -n $CUTBUFFER ]]; then
    # On Linux, use xclip or xsel
    echo "$CUTBUFFER" | xsel --clipboard --input

    # On macOS, use pbcopy
    # echo "$CUTBUFFER" | pbcopy
  fi
}

function yank_to_end_of_line_and_copy() {
 # Yank from the cursor to the end of the line manually
  local cursor_pos=${CURSOR}
  local line_end=${#BUFFER}
  
  # Copy the text from the cursor to the end of the line
  CUTBUFFER="${BUFFER:$cursor_pos:$line_end}"
  copy_to_clipboard     
}

#  for 'd' and 'D'
function delete_and_copy_to_clipboard() {
  zle kill-region       # Delete the text (similar to vi's delete command)
  copy_to_clipboard     # Copy the deleted text to the clipboard
}

function delete_to_end_of_line_and_copy() {
  zle kill-line         
  copy_to_clipboard     
}

# for y and Y
zle -N copy_to_clipboard
zle -N yank_to_end_of_line_and_copy
bindkey -M vicmd 'y' copy_to_clipboard
bindkey -M vicmd 'Y' yank_to_end_of_line_and_copy

# for D and d
zle -N delete_and_copy_to_clipboard
zle -N delete_to_end_of_line_and_copy
bindkey -M vicmd 'd' delete_and_copy_to_clipboard
bindkey -M vicmd 'D' delete_to_end_of_line_and_copy


# for whatever reason I need to export these locale
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#fly.io
export FLYCTL_INSTALL="/home/pedro/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$PATH"

# pip installed 
export PATH=$PATH:$HOME/.local/bin

# custom script
export PATH=$PATH:$HOME/.config/scripts/

# NVM
source /usr/share/nvm/init-nvm.sh  

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

 alias shell-config="vim ~/dotfiles/zsh/.zshrc"
 alias i3-config="vim ~/dotfiles/i3/.config/i3/config"
 alias term-config="vim ~/dotfiles/alacritty/.config/alacritty/alacritty.toml"
 alias vim-config="vim ~/dotfiles/nvim/.config/nvim/init.lua"
 alias nvim-config="vim ~/dotfiles/nvim/.config/nvim/init.lua"
 alias bar-config="vim ~/dotfiles/polybar/.config/polybar"
 alias git-config="vim ~/dotfiles/git/.gitconfig"
 alias rofi-config="nvim ~/dotfiles/rofi/.config/rofi/config.rasi"
 alias src="source ~/dotfiles/zsh/.zshrc"
 alias cpy="~/dotfiles/scripts/.config/scripts//clip.sh"
 alias ss="flameshot full -c -p ~/screen_shots"
 alias ss-gui="flameshot gui -p ~/screen_shots"
 alias cae="caps_as_esc.sh"
 alias connect-bluetooth="connect-bluetooth.sh"
 alias vim="nvim"
 alias a="cat ~/dotfiles/zsh/.zshrc| grep alias"
 alias j=z

# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

alias luamake=/home/pedro/.lua-ls/lua-language-server/3rd/luamake/luamake

## RUBY
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.1/bin"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

setopt extendedglob # for zsh globbing
