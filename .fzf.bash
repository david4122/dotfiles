# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.vim/bundle/fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.vim/bundle/fzf/bin"
fi
export FZF_DEFAULT_OPTS='--preview "(head -$LINES {} || ls -la {} || echo {}) 2>/dev/null" --color fg:238,bg:233,hl:121,fg+:245,bg+:235,hl+:121,info:144,prompt:161,spinner:135,pointer:135,marker:118 --no-bold'
export FZF_ALT_C_COMMAND='find . -type d 2>/dev/null'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.vim/bundle/fzf/shell/completion.bash" 2> /dev/null
complete -F _fzf_path_completion -o bashdefault la

# Key bindings
# ------------
source "$HOME/.vim/bundle/fzf/shell/key-bindings.bash"
