# Tmux Configuration Recommendations

## Current Structure
Your config is well-organized with two files:
- `tmux.conf` - Main configuration
- `tmux/tmux.mac.conf` - macOS-specific clipboard integration

---

## Suggested Improvements

### 1. True Color Support
Line 6 uses `xterm-256color`. For true color (important if your terminal supports it):
```tmux
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
```

### 2. Remove Version Check (Lines 130-140)
The `if` statement checking for tmux 2.4+ is outdated - tmux 2.4 was released in 2017. You can safely use only the modern syntax and remove the fallback:
```tmux
# REMOVE THIS:
if '[ $(printf "2.4\n`tmux -V | cut -d\  -f2`\n" | sort -V | head -1) = 2.4 ]' \
"\
    bind-key -T copy-mode-vi 'v' send -X begin-selection; \
    ...
" "\
    bind -t vi-copy 'v' begin-selection; \
    ...
"

# REPLACE WITH:
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection
bind-key -T copy-mode-vi 'C-c' send -X copy-selection
unbind -T copy-mode-vi MouseDragEnd1Pane
```

### 3. Focus Events
Enable focus events for better integration with Neovim/Vim:
```tmux
set -g focus-events on
```

### 4. Renumber Windows
When you close a window, the numbering has gaps. This fixes it:
```tmux
set -g renumber-windows on
```

### 5. Unused Variables
Lines 45-48 define separators that are never used:
```tmux
end_left=""
end_right=""
separator_right=""
separator_left=""
```
Either remove them or incorporate them into your `window-status-format` and `window-status-current-format`.

### 6. Pane Resize Increment
Your resize bindings (H/J/K/L) resize by 1 cell. Consider a larger increment:
```tmux
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
```

### 7. Status Right Performance
Line 65 runs `uptime | awk` every 5 seconds (`status-interval 5`). Consider:
- Increasing `status-interval` to 15-30 seconds
- Or simplifying/removing the uptime display

### 8. Aggressive Resize
Useful if you connect from multiple terminals of different sizes:
```tmux
set -g aggressive-resize on
```

### 9. Copy Mode Enhancements
Add rectangle selection in vi copy mode:
```tmux
bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
```

---

## Priority Fixes

1. Enable true color support
2. Remove outdated version check (lines 130-140)
3. Add `set -g renumber-windows on`
4. Add `set -g focus-events on`
5. Remove unused separator variables (lines 45-48)
