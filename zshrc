#! /bin/zsh
#
# ***************************
# * CONFIGURABLE PARAMETERS *
# ***************************
#
# Sync up directory where dotfiles are held
DOTFILES=/home/tvujec/Dropbox/System/dotfiles

# ********************
# * DOTFILES REFRESH *
# ********************
update_dotfiles () {
	local dotfile
	local dotsave

	while [[ $# -gt 0 ]] ; do
		dotfile=$HOME/.$1
		dotsave=$DOTFILES/$1
		if [[ -r $dotsave && ( ! -f $dotfile || $dotsave -nt $dotfile ) ]] ; then
			echo Updating $dotfile
			cp -p $dotsave $dotfile
			exec zsh
		fi
		shift
	done
}
update_dotfiles zshrc zlogout ssh/config

# ***************
# * ZSH OPTIONS *
# ***************

# *** CHANGING DIRECTORIES ***
#
# If a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# *** COMPLETION ***
#
# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word. That is,
# the cursor is moved to the end of the word if either a single match is
# inserted or menu completion is performed.
setopt ALWAYS_TO_END

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD

# Beep on an ambiguous completion. More accurately, this forces the completion
# widgets to return status 1 on an ambiguous completion, which causes the shell
# to beep if the option BEEP is also set; this may be modified if completion is
# called from a user-defined widget.
unsetopt LIST_BEEP

# *** EXPANSION AND GLOBBING ***
#
# Treat the '#', '~' and '^' characters as part of patterns for filename
# generation, etc. (An initial unquoted '~' always produces named directory
# expansion.)
setopt EXTENDED_GLOB

# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument list. This also applies to file
# expansion of an initial '~' or '='.
unsetopt NOMATCH

# If numeric filenames are matched by a filename generation pattern, sort the
# filenames numerically rather than lexicographically.
setopt NUMERIC_GLOB_SORT

# *** HISTORY ***
#
# Save each command's beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file.  The  format  of  this prefixed
# data is:
# : <beginning time>:<elapsed seconds>;<command>
setopt EXTENDED_HISTORY

# Do not enter command lines into the history list if they are duplicates of
# the previous event.
setopt HIST_IGNORE_DUPS

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space. Note that the command lingers in the internal history until the next
# command is entered before it vanishes, allowing you to briefly reuse or edit
# the line. If you want to make it vanish right away without entering another
# command, type a space and press return.
setopt HIST_IGNORE_SPACE

# This option both imports new commands from the history file, and also causes
# your typed commands to be appended to the history file (the latter is like
# specifying INC_APPEND_HISTORY). The history lines are also output with
# timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where
# we left off reading the file after it gets re-written).
# By default, history movement commands visit the imported lines as well as the
# local lines, but you can toggle this on and off with the set-local-history
# zle binding. It is also possible to create a zle widget that will make some
# commands ignore imported commands, and some include them.
setopt SHARE_HISTORY

# *** Job Control ***
#
# Send the HUP signal to running jobs when the shell exits.
unsetopt HUP

# *** SHELL EMULATION ***
#
# Causes field splitting to be performed on unquoted parameter expansions. Note
# that this option has nothing to do with word splitting.
setopt SH_WORD_SPLIT

# *** ZLE ***
#
# If ZLE is loaded, turning on this option has the equivalent effect of
# 'bindkey -e'. In addition, the VI option is unset. Turning it off has no
# effect. The option setting is not guaranteed to reflect the current keymap.
# This option is provided for compatibility; bindkey is the recommended
# interface.
setopt EMACS

# ******************
# * ZSH PARAMETERS *
# ******************

# *** HISTORY ***
#
# The file to save the history in when an interactive shell exits. If unset,
# the history is not saved.
HISTFILE=$HOME/.zhist

# The maximum number of events stored in the internal history list. If you use
# the HIST_EXPIRE_DUPS_FIRST option, setting this value larger than the
# SAVEHIST size will give you the difference as a cushion for saving duplicated
# history events.
HISTSIZE=100000

# The maximum number of history events to save in the history file.
SAVEHIST=100000

# *** PROMPT ***
#
# The primary prompt string, printed before a command is read. It undergoes a
# special form of expansion before being displayed. The default is '%m%# '.
PS1="%B%n%b@%B%m%b [%~]%# "

# This prompt is displayed on the right-hand side of the screen when the
# primary prompt is being displayed on the left. This does not work if the
# SINGLELINEZLE option is set. It is expanded in the same way as PS1.
RPS1=%T

# Magic to update xterm title. Modified from
# http://blog.bstpierre.org/zsh-prompt
function title() {
    # escape '%' chars in $1, make nonprintables visible
    local a="${(V)1//\%/\%\%}"

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")
    case $TERM in
        screen*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$a @ $2\e\\"   # screen location
            ;;
        xterm*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "%m%#%55<...<%~"
}

# preexec is called just before any command line is executed
function preexec() {
    title "$1" "%m%#%35<...<%~"
}

# The following lines were added by compinstall

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename "$HOME/.zshrc"

autoload -U compinit
compinit
# End of lines added by compinstall
