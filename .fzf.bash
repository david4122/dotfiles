# Setup fzf
# ---------
if [[ ! "$PATH" == */fzf/bin* ]]; then
	export PATH="$PATH:$HOME/fzf/bin"
fi
export FZF_DEFAULT_OPTS='--preview "(head -$LINES {} || ls -la {} || echo {}) 2>/dev/null" --color fg:238,bg:233,hl:121,fg+:245,bg+:235,hl+:121,info:144,prompt:161,spinner:135,pointer:135,marker:118 --no-bold'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/fzf/shell/completion.bash" 2> /dev/null
complete -F _fzf_path_completion -o bashdefault la

# Key bindings
# ------------
source "$HOME/fzf/shell/key-bindings.bash"
