function OpenDialog(filterlist::Cstring, defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = @ccall libnfd.NFD_OpenDialog(filterlist::Cstring, defaultpath::Cstring, outpath::Ref{Ptr{UInt8}})::NFDResult
    return status, outpath[]
end

function OpenDialogMultiple(filterlist::Cstring, defaultpath::Cstring)
    outpathset = Ref(NFDPathSet(C_NULL, C_NULL, 0))
    status = @ccall libnfd.NFD_OpenDialogMultiple(filterlist::Cstring, defaultpath::Cstring, outpathset::Ref{NFDPathSet})::NFDResult
    return status, outpathset[]
end

function SaveDialog(filterlist::Cstring, defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = @ccall libnfd.NFD_SaveDialog(filterlist::Cstring, defaultpath::Cstring, outpath::Ref{Ptr{UInt8}})::NFDResult
    return status, outpath[]
end

function PickFolder(defaultpath::Cstring)
    outpath = Ref(Ptr{UInt8}())
    status = @ccall libnfd.NFD_PickFolder(defaultpath::Cstring, outpath::Ref{Ptr{UInt8}})::NFDResult
    return status, outpath[]
end

function GetError()
    @ccall libnfd.NFD_GetError()::Cstring
end
