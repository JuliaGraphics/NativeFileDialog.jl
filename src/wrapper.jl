function OpenDialog(filterlist::Cstring, defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = ccall((:NFD_OpenDialog, libnfd), NFDResult, (Cstring, Cstring, Ref{Ptr{UInt8}}), filterlist, defaultpath, outpath)
    return status, outpath[]
end

function OpenDialogMultiple(filterlist::Cstring, defaultpath::Cstring)
    outpathset = Ref(NFDPathSet(C_NULL, C_NULL, 0))
    status = ccall((:NFD_OpenDialogMultiple, libnfd), NFDResult, (Cstring, Cstring, Ref{NFDPathSet}), filterlist, defaultpath, outpathset)
    return status, outpathset[]
end

function SaveDialog(filterlist::Cstring, defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = ccall((:NFD_SaveDialog, libnfd), NFDResult, (Cstring, Cstring, Ref{Ptr{UInt8}}), filterlist, defaultpath, outpath)
    return status, outpath[]
end

function PickFolder(defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = ccall((:NFD_PickFolder, libnfd), NFDResult, (Cstring, Ref{Ptr{UInt8}}), defaultpath, outpath)
    return status, outpath[]
end

function GetError()
    ccall((:NFD_GetError, libnfd), Cstring, ())
end

function PathSetFree(pathset::NFDPathSet)
    refpathset = Ref(pathset)
    ccall((:NFD_PathSet_Free, libnfd), Cvoid, (Ref{NFDPathSet},), refpathset)
end

function Free(ptr)
    ccall((:NFD_Free, libnfd), Cvoid, (Ptr{Cvoid},), ptr)
end
