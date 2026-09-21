function gx_box_nlfff_memory, lib_location, box, n_processes, estimate, available

; v 4.6.26.921 (rev.81)

sz = size(box.bx) 

np = lonarr(1)
np[0] = fix(n_processes)
est = ulon64arr(1)
avail = ulon64arr(1)

mem_ratio = CALL_EXTERNAL(lib_location, 'mfoNLFFFMemoryIDL', sz[1:3], np $
                    , est, avail $
                    , VALUE = [0, 0, 0, 0], /D_VALUE, /CDECL, /UNLOAD)

estimate = est[0]
available = avail[0]

return, mem_ratio

end
 