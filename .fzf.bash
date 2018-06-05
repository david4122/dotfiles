# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dawid/fzf/bin* ]]; then
  export PATH="$PATH:/home/dawid/fzf/bin"
fi
export FZF_DEFAULT_OPTS='--preview "head -$LINES {} 2>/dev/null || ls -la" --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81,info:144,prompt:161,spinner:135,pointer:135,marker:118'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/dawid/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/dawid/fzf/shell/key-bindings.bash"
