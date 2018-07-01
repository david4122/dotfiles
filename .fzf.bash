# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.vim/bundle/fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.vim/bundle/fzf/bin"
fi
export FZF_DEFAULT_OPTS='--preview "(head -$LINES {} || ls -la {} || echo {}) 2>/dev/null" --color fg:238,bg:233,hl:121,fg+:245,bg+:235,hl+:121,info:144,prompt:12,spinner:135,pointer:135,marker:118 --no-bold'
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' -not -name '.git' 2>/dev/null"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.vim/bundle/fzf/shell/completion.bash" 2> /dev/null
complete -F _fzf_path_completion -o bashdefault la

# Key bindings
# ------------
source "$HOME/.vim/bundle/fzf/shell/key-bindings.bash"

# Functions
fzf_tmux_pane_switcher() {
	local format current sep=','
	local reset="\033[0m" active="\033[38;5;184m" pane="\033[37m" window="\033[38;5;121m"

	format="#{session_id}:#{window_id}.#{pane_id}$sep[#{pane_active}#{window_active}] #{session_name}: #{window_name} [ #{pane_current_command} ] - #{pane_title}" 
	current=$(tmux display-message -p "$format")

	tmux lsp -aF "$format" \
		| grep -v "^${current%,*}" \
		| sort -rt"$sep" -k2 \
		| sed "s/\[11]/`printf "$active*$reset  "`/; s/\[10]/`printf "$window+$reset  "`/; s/\[01]/`printf "$pane-$reset  "`/; s/\[00]/     /" \
		| fzf +m --prompt 'jump to pane> ' --exit-0 --select-1 --ansi \
			--delimiter="$sep" --with-nth=2 \
			--preview='tmux capture-pane -pet {1} | tail -n $LINES' \
			--preview-window=up \
		| cut -d"$sep" -f1 \
		| xargs tmux switch-client -t 2>/dev/null
}
