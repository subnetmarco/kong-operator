function wait_for() {
	CMD=$1
	REGEX=$2
	TIMEOUT=$3

	echo "Trying '$CMD' ($TIMEOUT retries)..."

	local GOT_RESULT
	for i in $(seq $TIMEOUT); do
		if ! GOT_RESULT="$($CMD)"; then
			RETVAL=$?
			echo "Attempt $i: command exited with $RETVAL. Output: $GOT_RESULT'"
		else
			echo "Attempt $i: got '$GOT_RESULT', want =~ $REGEX"
		fi
		[[ "$GOT_RESULT" =~ $REGEX ]] && return 0
		sleep 1
	done

	echo "Timed out."
	return 1
}
