# Kill process(es) listening on a given TCP/UDP port
kp() {
  if [[ -z "$1" ]]; then
    echo "Usage: kp <port>"
    return 1
  fi

  local port="$1"
  local process_ids
  process_ids=$(lsof -t -i :"$port")

  if [[ -n "$process_ids" ]]; then
    # Convert to array to handle multiple PIDs properly
    local pids_array=($process_ids)
    local count=${#pids_array[@]}

    if [[ $count -eq 1 ]]; then
      echo "Killing process $process_ids using port $port"
    else
      echo "Found $count processes using port $port: $process_ids"
      echo "Killing all processes..."
    fi

    # Kill each process individually to handle errors better
    local failed_kills=()
    for pid in $pids_array; do
      if kill -9 "$pid" 2>/dev/null; then
        echo "  ✓ Killed process $pid"
      else
        failed_kills+=($pid)
        echo "  ✗ Failed to kill process $pid"
      fi
    done

    if [[ ${#failed_kills[@]} -eq 0 ]]; then
      echo "All processes terminated successfully"
    else
      echo "Failed to kill ${#failed_kills[@]} process(es): ${failed_kills[*]}"
      return 1
    fi
  else
    echo "No process is using port $port"
  fi
}

# Jump to directory with z and run opencode
zoc() {
  if [[ -z "$1" ]]; then
    echo "Usage: zoc <directory_pattern>"
    return 1
  fi

  # Use z to jump to directory
  z "$1"

  # Check if z command was successful (directory exists and was changed to)
  if [[ $? -eq 0 ]]; then
    # Check if opencode is installed
    if command -v opencode &> /dev/null; then
      # Open current directory with opencode
      opencode
    else
      echo "Neither opencode nor code command is available"
      return 1
    fi
  else
    echo "Directory not found or z command failed"
    return 1
  fi
}

# Jump to directory with z and run claude code
zcc() {
  if [[ -z "$1" ]]; then
    echo "Usage: zcc <directory_pattern>"
    return 1
  fi

  # Use z to jump to directory
  z "$1"

  # Check if z command was successful (directory exists and was changed to)
  if [[ $? -eq 0 ]]; then
    # Check if claude is installed
    if command -v claude &> /dev/null; then
      # Open current directory with claude
      claude
    else
      echo "Neither claude nor code command is available"
      return 1
    fi
  else
    echo "Directory not found or z command failed"
    return 1
  fi
}

znv() {
  if [[ -z "$1" ]]; then
    echo "Usage: zvi <directory_pattern>"
    return 1
  fi

  z "$1"
  if [[ $? -eq 0 ]]; then
    if command -v nvim &> /dev/null; then
      nvim
    else
      vim
    fi
  else
    echo "Directory not found or z command failed"
    return 1
  fi
}
