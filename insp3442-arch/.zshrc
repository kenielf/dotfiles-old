
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '/home/kenielf/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.shell_history
HISTSIZE=5000
SAVEHIST=50000
setopt autocd extendedglob
unsetopt beep notify
# End of lines configured by zsh-newuser-install

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.zsh"; then source "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.zsh"; fi
# END_KITTY_SHELL_INTEGRATION


###--- KEYBOARD CONFIGURATION ---###
# Keymaps
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Control word
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


###--- GENERAL SHELL CONFIGURATION ---###
# Plugins
source ~/.config/shell/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/shell/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Source shell config files
source ~/.config/shell/setup
source ~/.config/shell/alias

# ZSH Only
alias \$=""
alias \#="sudo "
alias srczsh="source ~/.zshrc"


###--- PROMPT ---###
# Test
# %(!.#.$)
# Fancy:  | [Z·uname@machine·~] λ
FPS1="%F{%(!.red.green)}[%F{white}Z%F{%(!.red.green)}·%F{blue}%n%F{%(!.red.green)}@%F{blue}%m%F{%(!.red.green)}·%F{white}%1~%F{%(!.red.green)}] λ%F{white} "
FRPS1=""
# Simple: | [Z·uname@machine·~] $ | | HH:MM:SS
SPS1="%F{%(!.red.green)}[%F{white}Z%F{%(!.red.green)}·%F{cyan}%n%F{%(!.red.green)}@%F{cyan}%m%F{%(!.red.green)}·%F{white}%1~%F{%(!.red.green)}] $%F{white} "
SRPS1="%F{%(!.red.green)}%D{%H:%M:%S}%F{white}"
case $(tty) in
    (/dev/tty[1-9]) PS1=$SPS1 && RPS1=$SRPS1;;
                (*) PS1=$FPS1 && RPS1=$FRSP1;;
esac
export PS1 && export RPS1

