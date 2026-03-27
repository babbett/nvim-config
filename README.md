# nvim Vanilla Config 
Use `bob` and select the nightly version for the vanilla package manager.

Should place in ~/.config/nvim

# Notes
**Hover (vim.lsp.buf.hover()):** `shift-K`, `shift-K-K` to go into the menu
**Native LSP hover:** `Ctrl-W-D` (window diagnostic)
**MiniPick:** `Ctrl-B, Ctrl-F` to scroll through options (back, forward)

## Buffers, Windows, and Tabs 
**Buffer:** text file in memory. 
- `:ls` to view them
**Window:** viewport on the buffer. 
- `:vsp` creates a vertical split, two viewports on one buffer. 
- `:b *name of buffer*` to show a buffer in a window
**Tabs:** collection of windows. Basically a layout, not actually a tab

## Commenting:
`g` is a weird command that puts vim into a mode i do not currently understand. does some useful stuff tho
`gc{motion}` comments out whatever is described by the motion
`gcc` comments out a single line (kinda?)
`gx` goes to the link/executes a program

## Terminal Mode: 
You can enter normal mode while in terminal mode by hitting `C-\` followed by `C-n`

## Rot13

Rot13 a buffer with `ggg?G`
why is this even a thing???

## Future TODOs
I would like a tool that lets you attach notes to a file without cluttering the actual file.

Basically a file somewhere with a directory of notes, and a map from a filename/path to the correct note? then you hit the vim command and it pulls up a little text box which shows the notes collected from the file.

you could maybe add a panel that also shows all the #TODOs on the current file, or directory specific notes or something. idk, could be cool
