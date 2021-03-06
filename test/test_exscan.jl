using Base.Test

using MPI

MPI.Init()

comm = MPI.COMM_WORLD
size = MPI.Comm_size(comm)
rank = MPI.Comm_rank(comm)

# Not possible to PROD a Char (and neither Int8 with OpenMPI)
typs = setdiff([(isdefined(:UnionAll) ? Base.uniontypes(MPI.MPIDatatype) : MPI.MPIDatatype.types)...], [Char, Int8, UInt8])
for typ in typs
    val = convert(typ,rank+1)
    B = MPI.Exscan(val, MPI.PROD, comm)
    if rank > 0
        @test B[1] === convert(typ, factorial(rank))
    end
end

MPI.Finalize()
