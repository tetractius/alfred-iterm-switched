#!/bin/bash
# Alfred Script Filter: list open iTerm2 tabs matching the query.
osascript -l JavaScript - "$1" <<'JXA'
function run(argv) {
  var query = (argv[0] || "").toLowerCase();
  var app = Application("iTerm2");
  var items = [];

  if (!app.running()) {
    return JSON.stringify({ items: [{ title: "iTerm2 is not running", subtitle: "Launch iTerm2 and try again", valid: false }] });
  }

  var windows = app.windows();
  for (var w = 0; w < windows.length; w++) {
    var win = windows[w];
    var winId;
    try { winId = win.id(); } catch (e) { continue; }

    var tabs = win.tabs();
    for (var t = 0; t < tabs.length; t++) {
      var tab = tabs[t];
      var title = "";
      try { title = tab.currentSession().name(); } catch (e) { title = "(untitled)"; }

      if (query && title.toLowerCase().indexOf(query) === -1) continue;

      items.push({
        title: title,
        subtitle: "Window " + (w + 1) + " · Tab " + (t + 1),
        arg: winId + ":" + (t + 1)
      });
    }
  }

  if (items.length === 0) {
    items.push({ title: "No matching iTerm tabs", subtitle: query ? ("No tab title contains \"" + query + "\"") : "No open iTerm tabs found", valid: false });
  }

  return JSON.stringify({ items: items });
}
JXA
