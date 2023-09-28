using VfldFiles, Glob, Plots, DataFrames


archive2="/home/roels/monitordata/"
exp="oops_3denvar_ref"
dts(dt) = Dates.format(dt,"yyyymmddHH") 
fcint=Hour(3)
vars=[:ID,:TT,:DD]

#function omb(archive,exp,dtg,mbr="")
    bg  = read_v("$archive2/$exp/vfld$(exp)$(mbr)$(dts(dtg-fcint))03",select=vars)
    obs = read_v("$archive2/$exp/vobs$(dts(dtg))",select=vars)
    IDS = intersect(bg[:,:ID] ,obs[:,:ID])

    diff = bg[]
    df = innerjoin(obs,bg,on=[:ID,:validtime],makeunique=true, renamecols = "_obs" => "_bg")    
    groupby(df,[exp])
    df[:omb] = df[:,:TT_obs] - df[:,:TT_bg]
# end 

vobsfiles = glob("vobs*",exp)
vfldfiles = glob("vfld*",exp)


obs_df = reduce(vcat, read_v.(vobsfiles,select=[:ID,:TT]))
vfld_df = reduce(vcat, read_v.(vfldfiles,select=[:ID,:TT]))

vobsfld = innerjoin(vfld_df,obs_df,on=[:ID,:validtime],makeunique=true, renamecols = "_vfld" => "_vobs")

vobsdlf[:]

gdf=groupby(vobsfld,[:leadtime])

function plotind(gdf,i)
    p = scatter(gdf[i][:,:TT_1],gdf[i][:,:TT],legend=false,markersize=2);
    title!(p,string((keys(gdf)[i]).leadtime))
    plot!(p,[250, 300],[250, 300],linewidth=3)
    xlabel!(p,"obs")
    ylabel!(p,"fc")

    return p 
end 


plot(plotind(gdf,1), plotind(gdf,3), plotind(gdf,5), plotind(gdf,11), layout=grid(2,2))
```