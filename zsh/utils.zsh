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
    echo "Killing process(es) $process_ids using port $port"
    kill -9 $process_ids
    echo "Process(es) terminated"
  else
    echo "No process is using port $port"
  fi
}
