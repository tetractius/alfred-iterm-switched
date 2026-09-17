#!/bin/bash
# Alfred Run Script: focus a specific iTerm2 window/tab.
# Receives "$1" as "<windowId>:<tabIndex>" (the arg produced by filter.sh).
arg="$1"
winId="${arg%%:*}"
tabIndex="${arg##*:}"

osascript - "$winId" "$tabIndex" <<'APPLESCRIPT'
on run argv
  set winId to (item 1 of argv) as integer
  set tabIdx to (item 2 of argv) as integer
  tell application "iTerm2"
    activate
    set targetWindow to window id winId
    select targetWindow
    set targetTab to tab tabIdx of targetWindow
    select targetTab
  end tell
end run
APPLESCRIPT
