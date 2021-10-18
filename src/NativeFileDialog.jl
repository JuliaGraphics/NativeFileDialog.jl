module NativeFileDialog

using NativeFileDialog_jll

export pick_file, pick_multi_file, pick_folder, save_file

@enum NFDResult NFD_ERROR=0 NFD_OKAY=1 NFD_CANCEL=2

mutable struct NFDPathSet
    buf::Ptr{UInt8}
    indices::Ptr{Csize_t}
    count::Csize_t
end

NFDPathSet() = NFDPathSet(C_NULL, C_NULL, 0)

include("wrapper.jl")

Base.length(pathset::NFDPathSet) = pathset.count

function getindices(pathset::NFDPathSet)
    count = length(pathset)
    unsafe_load.(pathset.indices, 1:count)
end

function getpaths(pathset::NFDPathSet)
    unsafe_string.(pathset.buf .+ getindices(pathset))
end

"""
    pick_file(;path="", filterlist="")

Open an OS native window to select a file.

Returns the absolute path of the selected file or an empty string in case the
operation was cancelled.

# Examples
```jldoctest
julia> pick_file() # the selection window is open
"/home/user/file.txt" # MacOS/Linux

julia> pick_file()
"C\\:Users\\user\\Documents\\file.txt" # Windows

julia> pick_file()
"" # cancelled
```
"""
function pick_file(;path="", filterlist="")
    filters = isempty(filterlist) ? Cstring(C_NULL) : Cstring(pointer(filterlist))
    path = isempty(path) ? Cstring(C_NULL) : Cstring(pointer(path))
    status, outpath = OpenDialog(filters, path)
    if status == NFD_ERROR
        error(unsafe_string(GetError()))
    elseif status == NFD_OKAY
        out = unsafe_string(outpath)
        Free(outpath)
    elseif status == NFD_CANCEL
        out = ""
    else
        error("Unkown status return ($status)")
    end
    return out
end

"""
    pick_multi_file(;path="", filterlist="")

Open an OS native window to select multiple files.

Returns an array of the absolute paths of the selected files or an empty vector
in case the operation was cancelled.

# Examples
```jldoctest
julia> pick_multi_file() # the selection window is open
["/home/user/file1.txt", "/home/user/file2.txt"] # MacOS/Linux

julia> pick_multi_file()
["C\\:Users\\user\\Documents\\file1.txt", "C\\:Users\\user\\Documents\\file2.txt"] # Windows

julia> pick_multi_file()
String[] # cancelled
```
"""
function pick_multi_file(;path="", filterlist="")
    filters = isempty(filterlist) ? Cstring(C_NULL) : Cstring(pointer(filterlist))
    path = isempty(path) ? Cstring(C_NULL) : Cstring(pointer(path))
    status, outpath = OpenDialogMultiple(filters, path)
    if status == NFD_ERROR
        error(unsafe_string(GetError()))
    elseif status == NFD_OKAY
        out = getpaths(outpath)
        PathSetFree(outpath)
    elseif status == NFD_CANCEL
        out = String[]
    else
        error("Unkown status return ($status)")
    end
    return out
end

"""
    save_file(;path="", filterlist="")

Open an OS native window to set the location and name to save a file.

Returns the absolute path of the selected name and location for the file or an
empty string in case the operation was cancelled.

# Examples
```jldoctest
julia> save_file() # the selection window is open
"/home/user/file1.txt" # MacOS/Linux example

julia> save_file()
"C\\:Users\\user\\Documents\\file1.txt" # Windows

julia> save_file()
"" # cancelled
```
"""
function save_file(;path="", filterlist="")
    filters = isempty(filterlist) ? Cstring(C_NULL) : Cstring(pointer(filterlist))
    path = isempty(path) ? Cstring(C_NULL) : Cstring(pointer(path))
    status, outpath = SaveDialog(filters, path)
    if status == NFD_ERROR
        error(unsafe_string(GetError()))
    elseif status == NFD_OKAY
        out = unsafe_string(outpath)
        Free(outpath)
    elseif status == NFD_CANCEL
        out = ""
    else
        error("Unkown status return ($status)")
    end
    return out
end

"""
    pick_folder(;path="")

Open an OS native window to select a directory.

Returns the absolute path of the selected directory or an empty string in case
the operation was cancelled.

# Examples
```jldoctest
julia> pick_folder() # the selection window is open
"/home/user/dir" # MacOS/Linux

julia> pick_folder()
"C\\:Users\\user\\Documents\\dir" # Windows

julia> pick_folder()
"" # cancelled
```
"""
function pick_folder(;path="")
    path = isempty(path) ? Cstring(C_NULL) : Cstring(pointer(path))
    status, outpath = PickFolder(path)
    if status == NFD_ERROR
        error(unsafe_string(GetError()))
    elseif status == NFD_OKAY
        out = unsafe_string(outpath)
        Free(outpath)
    elseif status == NFD_CANCEL
        out = ""
    else
        error("Unkown status return ($status)")
    end
    return out
end

end
