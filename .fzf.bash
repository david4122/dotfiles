# Setup fzf
# ---------
if [[ ! "$PATH" == "*$HOME/.vim/bundle/fzf/bin*" ]]; then
	export PATH="$PATH:$HOME/.vim/bundle/fzf/bin"
fi

export FZF_COLOR_SCHEME='fg:238,bg:233,hl:121,fg+:245,bg+:235,hl+:121,info:144,prompt:12,spinner:135,pointer:135,marker:118'
export FZF_DEFAULT_OPTS="--preview \"(head -\$LINES {} || ls -la {} || echo {}) 2>/dev/null\" --color \"$FZF_COLOR_SCHEME\" --no-bold"
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
	local format current sep=$'\t'
	local reset="\033[0m" active="\033[38;5;184m" pane="\033[37m" window="\033[38;5;121m"

	format="#{session_id}:#{window_id}.#{pane_id}$sep[#{window_active}#{pane_active}]$sep#{session_name}: #{window_name} [ #{pane_current_command} ] - #{pane_title}"
	current=$(tmux display-message -p "$format")

	tmux lsp -aF "$format" \
		| grep -v "^${current%%$sep*}" \
		| sort -rt"$sep" -k2 \
		| sed "s/\[11]/`printf "$active*$reset"`/; s/\[10]/`printf "$window+$reset"`/; s/\[01]/`printf "$pane-$reset"`/; s/\[00]//" \
		| fzf +m --prompt 'jump to pane> ' --exit-0 --select-1 --ansi \
			--cycle --delimiter="$sep" --with-nth=2,3 \
			--preview='tmux capture-pane -pet {1} | tail -n $LINES' \
			--preview-window=up:60% \
		| cut -d"$sep" -f1 \
		| xargs tmux switch-client -t 2>/dev/null
}

fzf_tmux_kill_session() {
	tmux kill-session -t $(tmux ls | fzf | cut -d: -f1)
}

mc_hotlist() {
	local entry
	set -o history
	entry=$(awk '/GROUP/{GROUP=$2} /ENTRY/{print GROUP, $2, $4}' ~/.config/mc/hotlist | fzf --reverse --height 15 | cut -d\  -f3)
	if [ -n "$entry" ]; then
		cmd="mc '${entry//\"/}' ."
		history -s "$cmd"
		eval "$cmd"
	fi
}

mc_netrc() {
	local entry
	set -o history
	entry=$(awk '{printf "[%s]@%s\n", $4, $2}' ~/.netrc | fzf --reverse --height 15)
	if [ -n "$entry" ]; then
		cmd="mc 'ftp://${entry##*\@}/' ."
		history -s "$cmd"
		eval "$cmd"
	fi
}

build_filelist() {
	if [ -z "$1" ]; then
		echo 'Usage: build_filelist [OUTPUT]' >&1
		return 1
	fi

	while true; do
		fname=$(fzf -m --preview="cat $1 || echo --------")
		[ -z "$fname" ] && break
		echo "$fname" >> "$1"
	done
}
