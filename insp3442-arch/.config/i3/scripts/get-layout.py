#!/usr/bin/env python3
import i3ipc

# Get i3 IPC connection
i3 = i3ipc.Connection()
parent = i3.get_tree().find_focused().parent

# Print status
if parent.layout == "splitv":
    print("V")
elif parent.layout == "splith":
    print("H")
else:
    print("-")

