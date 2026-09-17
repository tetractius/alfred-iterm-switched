#!/usr/bin/env python3
"""Builds info.plist and packages the .alfredworkflow file from the source scripts."""
import plistlib
import os
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.abspath(os.path.join(HERE, ".."))

FILTER_UID = "74ECA39D-12D3-4CD6-B2BD-73D61B3C0E16"
SELECT_UID = "5D9CD256-8657-4FEB-89F1-28522DFAD7A0"

with open(os.path.join(HERE, "filter.sh")) as f:
    filter_script = f.read()
with open(os.path.join(HERE, "select.sh")) as f:
    select_script = f.read()

plist = {
    "bundleid": "com.fil.itermtabswitcher",
    "category": "Tools",
    "connections": {
        FILTER_UID: [
            {
                "destinationuid": SELECT_UID,
                "modifiers": 0,
                "modifiersubtext": "",
                "vitoclose": False,
            }
        ]
    },
    "createdby": "Fil",
    "description": "Search open iTerm2 tabs by title and bring the matching window/tab to the front.",
    "disabled": False,
    "name": "iTerm Tab Switcher",
    "objects": [
        {
            "config": {
                "alfredfiltersresults": False,
                "alfredfiltersresultsmatchmode": 0,
                "argumenttreatemptyqueryasnil": True,
                "argumenttype": 1,
                "escaping": 102,
                "keyword": "itw",
                "queuedelaycustom": 3,
                "queuedelayimmediatelyinitially": False,
                "queuedelaymode": 0,
                "queuemode": 1,
                "runningsubtext": "Searching iTerm tabs...",
                "script": filter_script,
                "scriptargtype": 1,
                "scriptfile": "",
                "subtext": "",
                "title": "Search iTerm tabs by title",
                "type": 0,
                "withspace": True,
            },
            "type": "alfred.workflow.input.scriptfilter",
            "uid": FILTER_UID,
            "version": 3,
        },
        {
            "config": {
                "concurrently": False,
                "escaping": 102,
                "script": select_script,
                "scriptargtype": 1,
                "scriptfile": "",
                "type": 0,
            },
            "type": "alfred.workflow.action.script",
            "uid": SELECT_UID,
            "version": 2,
        },
    ],
    "readme": (
        "iTerm Tab Switcher\n\n"
        "Type \"itw\" followed by (part of) a tab's title to search every open "
        "iTerm2 window/tab, then press Enter to bring that exact tab to the front."
    ),
    "uidata": {
        FILTER_UID: {"xpos": 210, "ypos": 210},
        SELECT_UID: {"xpos": 460, "ypos": 210},
    },
    "userconfigurationconfig": [],
    "variables": {},
    "variablesdontexport": [],
    "version": "1.0",
    "webaddress": "",
}

info_plist_path = os.path.join(HERE, "info.plist")
with open(info_plist_path, "wb") as f:
    plistlib.dump(plist, f, fmt=plistlib.FMT_XML)

workflow_path = os.path.join(OUT_DIR, "iTerm Tab Switcher.alfredworkflow")
if os.path.exists(workflow_path):
    os.remove(workflow_path)

with zipfile.ZipFile(workflow_path, "w", zipfile.ZIP_DEFLATED) as z:
    z.write(info_plist_path, "info.plist")

print("Wrote", info_plist_path)
print("Wrote", workflow_path)
