#!/bin/bash
# Alfred Script Filter: list open iTerm2 tabs matching the query.
# AppleScript (not JXA) because JXA can't bridge iTerm2's "variable named"
# command (used below to read the tab's current directory).
osascript - "$1" <<'APPLESCRIPT'
on escapeJSON(txt)
	set txt to my replaceText(txt, "\\", "\\\\")
	set txt to my replaceText(txt, "\"", "\\\"")
	return txt
end escapeJSON

on replaceText(theText, searchStr, replaceStr)
	set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, searchStr}
	set theItems to text items of theText
	set AppleScript's text item delimiters to replaceStr
	set theText to theItems as text
	set AppleScript's text item delimiters to tid
	return theText
end replaceText

on run argv
	set query to ""
	if (count of argv) > 0 then set query to item 1 of argv

	set itemsJSON to {}
	tell application "iTerm2"
		set wIdx to 0
		repeat with w in windows
			set wIdx to wIdx + 1
			set wid to id of w
			set tIdx to 0
			repeat with t in tabs of w
				set tIdx to tIdx + 1
				set sName to ""
				set sPath to ""
				try
					tell current session of t
						set sName to name
						try
							set sPath to variable named "session.path"
						end try
					end tell
				end try

				set matched to true
				if query is not "" then
					ignoring case
						if sName does not contain query then set matched to false
					end ignoring
				end if

				if matched then
					set subt to "Window " & wIdx & " · Tab " & tIdx
					if sPath is not "" then set subt to subt & " · " & sPath
					set itemJSON to "{\"title\":\"" & my escapeJSON(sName) & "\",\"subtitle\":\"" & my escapeJSON(subt) & "\",\"arg\":\"" & wid & ":" & tIdx & "\"}"
					set end of itemsJSON to itemJSON
				end if
			end repeat
		end repeat
	end tell

	if (count of itemsJSON) is 0 then
		set itemsJSON to {"{\"title\":\"No matching iTerm tabs\",\"valid\":false}"}
	end if

	set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, ","}
	set joined to itemsJSON as text
	set AppleScript's text item delimiters to tid

	return "{\"items\":[" & joined & "]}"
end run
APPLESCRIPT
