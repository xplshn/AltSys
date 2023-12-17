if grep -qF 'live.accessibility' /proc/cmdline >/dev/null 2>&1; then
	live-audio -u 2>&1 | tee /tmp/live-audio.log
	live-audio -p 2>&1 | tee -a /tmp/live-audio.log
fi
