WORKING_WORKSPACE_NAME="working"

# If the shell is interactive and not in a tmux session, and the WORKING_WORKSPACE_NAME is set,
# then create a new tmux session with the WORKING_WORKSPACE_NAME.
# If the WORKING_WORKSPACE_NAME is not set, then create a new tmux session with the default name.
if [[ -n $PS1 ]]; then
    if [[ -z $TMUX ]]; then
        if [[ -n $WORKING_WORKSPACE_NAME ]]; then
            tmux new -A -t "$WORKING_WORKSPACE_NAME"
            tmux attach-session -t "$WORKING_WORKSPACE_NAME"
            return
        else
            tmux new -A -t default
            return
        fi
    fi
fi
