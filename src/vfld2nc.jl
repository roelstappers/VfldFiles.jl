
"""
   Converts vfld and vobs files to Netcdf files

   Netcdf files are stored as `fname.nc` 
"""

struct Experiment 
    name::String 
    mbr::Array{String}
    dtg::Array{DateTime}   
    lt::Array{TimePeriod}
end 


function vfld2nc_new(dir=VfldFiles.MEPS_prod; time, lt = 0:3:9,mbr=0:3)

    #todo: use CF conventions for all vars /dims 
    exp = "MEPS_prod"
    datestr= "2019021700"
    attrib = OrderedDict("exp" => exp )

    ds = Dataset("test.nc","c",attrib = attrib )

    nsid = 1203
    # Dimensions 
    defDim(ds,"SID", nsid) 
    defDim(ds,"mbr",length(mbr)); defVar(ds,"mbr",lpad.(mbr,3,"0"),("lt",))        
    defDim(ds,"leadtime",length(lt));   defVar(ds,"leadtime",lt,("leadtime",))        
    
    # Variables 
    data = fill(0.0,nsid,length(mbr),length(lt))
    defVar(ds,"t2m",data,("SID","mbr","leadtime"))  
    
    for (mbri,mbr) in enumerate(mbr) 
        for (lti,lt) in enumerate(lt)
            fname=joinpath(dir,"vfld$(exp)mbr$(lpad(mbr,3,"0"))$datestr$(lpad(lt,2,"0"))")
            df = read_v(fname) 
            ds["t2m"][:,mbri,lti] = df[:,:TT]

       end 
    end 

    close(ds) 
end 

   

# function vfld2nc(fname) 
#     io = open(fname)
#     @show fname
#     nt = read_header(io)
#     select = isempty(select) ? nt.header : select
#     df = read_synop(io; select=select, nt...)
#     close(io)


#     type, exp, mbr, datetime, lt = splitfilename(basename(fname))

#     Dataset("$fname.nc","c",attrib = OrderedDict("exp" => exp)) do ds 
        
#         nsid = nrow(df)   # number of stations 

#         defDim(ds,"SID",nsid) # Dimension Station id
#         defDim(ds,"time",Inf)
#         defDim(ds,"mbr",Inf)
#         defDim(ds,"lt",Inf)        
#         defVar(ds,"SID",df[:,:ID],("SID",))
#         @show DateTime(datetime,"yyyymmddHH")
#         defVar(ds,"time",[string(datetime)],("time",))
#         defVar(ds,"mbr",[string(mbr)],("mbr",))
#         defVar(ds,"lt",[string(lt)],("lt",))
        
#         for var in names(df)
#             # println(var)
#             ff = reshape(df[:,var],nsid,1,1,1)
#             defVar(ds,var,ff,("SID","mbr", "time","lt"))
#         end        
#     end  
    
