# iTerm Tab Switcher (Alfred workflow)

An Alfred (5.8+) workflow that lets you search every open iTerm2 window/tab by
title and jump straight to it — like `⇧⌘O` inside iTerm2, but from Alfred.

## Install

Double-click `iTerm Tab Switcher.alfredworkflow` to import it into Alfred.

## Use

In Alfred, type:

```
itw <part of a tab title>
```

Every open iTerm2 tab whose title contains that text is listed (window +
tab position shown as the subtitle). Press Enter on a result to bring that
exact window and tab to the front.

Typing `itw` with no query lists all open tabs.

## How it works

- **Script Filter** (`workflow-src/filter.sh`): runs a JXA (`osascript -l
  JavaScript`) snippet that enumerates `Application("iTerm2").windows()` →
  `.tabs()` → `.currentSession().name()`, filters by the query
  (case-insensitive substring match), and emits Alfred's JSON item format.
  Each item's `arg` encodes `<windowId>:<tabIndex>`.
- **Run Script** (`workflow-src/select.sh`): receives that `arg`, splits out
  the window id and tab index, and runs an AppleScript that does
  `select window id ...` / `select tab ...` and activates iTerm2, bringing
  that specific tab to the foreground.

Window ids are iTerm2's own stable per-window identifiers, so switching
still works correctly even if windows/tabs have been reordered or closed
since the search was run.

## Rebuilding

The packaged `.alfredworkflow` is generated from the source scripts, not
hand-edited. After changing `workflow-src/filter.sh` or
`workflow-src/select.sh`, rebuild with:

```
python3 workflow-src/build.py
```

This regenerates `workflow-src/info.plist` and re-zips
`iTerm Tab Switcher.alfredworkflow`.

## Requirements

- Alfred 5 (Powerpack) with the "Allow Alfred to control this computer"
  Accessibility/Automation permission granted (Alfred will prompt for this
  the first time the workflow runs).
- iTerm2, with Automation permission granted to Alfred/osascript the first
  time it's asked (System Settings → Privacy & Security → Automation).
