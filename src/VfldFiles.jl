module VfldFiles

import CSV
using Dates, DataFrames, NCDatasets, OrderedCollections
using  Artifacts , Glob

export read_v
export archive,MEPS_prod, obs, vfld2nc_new

const archive   = joinpath(artifact"vfldtestdata","Vfldtestdata-0.1.0")
const MEPS_prod = joinpath(archive,"vfld/MEPS_prod") 
const obs       = joinpath(archive,"vobs") 

include("read.jl")
include("vfld2nc.jl")

  
end # module VfldFiles
