# NativeFileDialog

[![Build Status](https://github.com/Suavesito-Olimpiada/NativeFileDialog.jl/workflows/CI/badge.svg)](https://github.com/Suavesito-Olimpiada/NativeFileDialog.jl/actions)
[![Coverage](https://codecov.io/gh/Suavesito-Olimpiada/NativeFileDialog.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Suavesito-Olimpiada/NativeFileDialog.jl)


Wrapper of the library
[mlabbe/nativefiledialog](https://github.com/mlabbe/nativefiledialog) for
opening native OS dialogues for selecting files (or Gtk for Linux/FreeBSD).
Inspired by [this discourse
post](https://discourse.julialang.org/t/file-choose-in-julia/69703).

## Installation

To install NativeFileDialog.jl, in the Julia REPL

```julia
julia> using Pkg
julia> Pkg.add("NativeFileDialog")
```

# Documentation

NativeFileDialog.jl export four functions

```julia
pick_file(path=""; filterlist="")

pick_multi_file(path=""; filterlist="")

pick_folder(path="")

save_file(path=""; filterlist="")
```

The documentation of every one of these can be consulted in help mode in the REPL
(press `?` to change to help mode, `backspace` to exit), although their names
are really descriptive.

### Path selection

The `path` positional argument sets the directory in which the dialog will be
open, by default `path` is set to `""` and the default open point is operating
system dependent.

The `path` argument accepts `AbstractPath`s from
[FilePathsBase.jl](https://github.com/rofinn/FilePathsBase.jl). It always
returns `String`s given that there is not sensible way to tell the user if the
selection was cancelled with the default behaviour of FilePathsBase.jl (an
empty string is interpreted as the current directory).

### File filter lists

The `filterlist` keyword argument allows you to define multiple extension
filters for the dialogues. The syntax for doing this is `"ext1,ext2;ext3"`
where `ext1` and `ext2` are extensions of the first filter list and `ext3` is
an extension for the second one.

Notice that multiple extensions for one list are separated by a comma (`,`),
while the different lists are separated by a semicolon (`;`).

By default `filterlist` is set to `""` which means all kind of files are
accepted.

## Examples

```julia
julia> using NativeFileDialog

julia> using FilePathsBase

julia> pick_file()
"/home/suave/primes.c"

julia> pick_file(home()) # from FilePathsBase
"/home/suave/donut.c"

julia> pick_file()
"" # cancelled selection

julia> pick_multi_file()
2-element Vector{String}:
 "/home/suave/aek.cpp"
 "/home/suave/aek.ppm"

julia> pick_folder()
"/home/suave"
```

