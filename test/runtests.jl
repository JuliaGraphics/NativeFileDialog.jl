using NativeFileDialog
using Test

import NativeFileDialog: getindices, getpaths, NFDPathSet

@testset "NativeFileDialog.jl" begin
    @test length(NFDPathSet()) == 0
    @test getindices(NFDPathSet()) == UInt[]
    @test getpaths(NFDPathSet()) == String[]

    paths = "a\0b"
    GC.@preserve paths begin
        indices = [0, 2]
        count = 2
        pathset = NFDPathSet(
                    pointer(paths),
                    convert(Ptr{Csize_t}, pointer(indices)),
                    convert(Csize_t, count))

        @test length(pathset) == 2
        @test getindices(pathset) == indices
        @test getpaths(pathset) == ["a", "b"]
    end
end
