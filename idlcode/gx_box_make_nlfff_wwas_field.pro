;
; IDL Wrapper to external call of Weighted Wiegelmann NLFF Field Reconstruction Method library
; v 2.3.21.217 (rev.392)
; min WWWNLFFFReconstruction version: v 2.3.21.217 (rev.392)
; 
; Call:
; rc = gx_box_make_nlfff_wwas_field(lib_location, box, _extra = _extra)
; 
; Parameters description (see also section Comments below):
; 
; Parameters required:
;   (in)      lib_location    - full path to calling library
;   (in/out)  box             - GX-simulator box with initial model of field bx, by, bz
;   
; Parameters optional (in):
;   (in)      weight_bound_size    - weight bounary buffer zone size (in parts of corresponding dim. size),
;                                    default is 0.1 (i.e. buffer zone is 10% of dimension size from all boundaries,
;                                    except photosphere plain). Use weight_bound_size = 0 for no-buffer-zone approach 
; 
; Return code:
;   0, if everything is OK
;   non-zero in the case of errors
;   ...... (values are subject to specify)
; 
;   Note, that wrapping library also provides interfaces for C/C++, Python, and MATLAB
;   
; (c) Alexey G. Stupishin, Saint Petersburg State University, Saint Petersburg, Russia, 2017-2022
;     mailto:agstup@yandex.ru
;
;
;--------------------------------------------------------------------------;
;     \|/     Set the Controls for the Heart of the Sun           \|/      ;
;    --O--        Pink Floyd, "A Saucerful Of Secrets", 1968     --O--     ;
;     /|\                                                         /|\      ;  
;--------------------------------------------------------------------------;
;
;-------------------------------------------------------------------------------------------------
function gx_box_make_nlfff_wwas_field, lib_location, box, version_info = version_info, _extra = _extra

  version_info = gx_box_field_library_version(lib_location)
;    print, version_info
  
  abs_field = 0L
  abs_field_weight = 0L
  los_projection = 0L
  los_projection_weight = 0L
  los_projection_dir_cos = 0L
  field_component_x = 0L
  field_component_x_weight = 0L
  field_component_y = 0L
  field_component_y_weight = 0L
  field_component_z = 0L
  field_component_z_weight = 0L
  abs_field_max = 0L
  abs_field_max_weight = 0L
  los_projection_max = 0L
  los_projection_max_weight = 0L
  field_component_x_max = 0L
  field_component_x_max_weight = 0L
  field_component_y_max = 0L
  field_component_y_max_weight = 0L
  field_component_z_max = 0L
  field_component_z_max_weight = 0L
  value = bytarr(26)
  value[0:4] = 0 
  value[5:25] = 1 
  
  n = n_tags(_extra)
  parameterMap = replicate({itemName:'',itemvalue:0d},n+1)
  nParameters = 0;
  if n gt 0 then begin
    keys = strlowcase(tag_names(_extra))
    for i = 0, n-1 do begin
      case keys[i] of
        'abs_field': begin
            abs_field = double(_extra.(i))
            value[5] = 0
          end
        'abs_field_weight': begin 
            abs_field_weight = double(_extra.(i))
            value[6] = 0
          end
        'los_projection': begin
            los_projection = double(_extra.(i))
            value[7] = 0
          end
        'los_projection_weight': begin 
            los_projection_weight = double(_extra.(i))
            value[8] = 0
          end
        'los_projection_dir_cos': begin 
            los_projection_dir_cos = double(_extra.(i))
            value[9] = 0
          end
        'field_component_x': begin 
            field_component_x = double(_extra.(i))
            value[10] = 0
          end
        'field_component_x_weight': begin 
            field_component_x_weight = double(_extra.(i))
            value[11] = 0
          end
        'field_component_y': begin 
            field_component_y = double(_extra.(i))
            value[12] = 0
          end
        'field_component_y_weight': begin 
            field_component_y_weight = double(_extra.(i))
            value[13] = 0
          end
        'field_component_z': begin 
            field_component_z = double(_extra.(i))
            value[14] = 0
          end
        'field_component_z_weight': begin 
            field_component_z_weight = double(_extra.(i))
            value[15] = 0
          end

        'abs_field_max': begin
            abs_field_max = double(_extra.(i))
            value[16] = 0
          end
        'abs_field_max_weight': begin 
            abs_field_max_weight = double(_extra.(i))
            value[17] = 0
          end
        'los_projection_max': begin
            los_projection_max = double(_extra.(i))
            value[18] = 0
          end
        'los_projection_max_weight': begin 
            los_projection_max_weight = double(_extra.(i))
            value[19] = 0
          end
        'field_component_x_max': begin 
            field_component_x_max = double(_extra.(i))
            value[20] = 0
          end
        'field_component_x_max_weight': begin 
            field_component_x_max_weight = double(_extra.(i))
            value[21] = 0
          end
        'field_component_y_max': begin 
            field_component_y_max = double(_extra.(i))
            value[22] = 0
          end
        'field_component_y_max_weight': begin 
            field_component_y_max_weight = double(_extra.(i))
            value[23] = 0
          end
        'field_component_z_max': begin 
            field_component_z_max = double(_extra.(i))
            value[24] = 0
          end
        'field_component_z_max_weight': begin 
            field_component_z_max_weight = double(_extra.(i))
            value[25] = 0
          end
        else: begin
            v = _extra.(i)
            if isa(v, /number) && ~isa(v, /array) && imaginary(v) eq 0 then begin
                parameterMap[nParameters].itemName = keys[i]
                parameterMap[nParameters].itemValue = v
                nParameters = nParameters + 1
            end
          end
      endcase
    endfor
  endif
  parameterMap[nParameters].itemName = '!____idl_map_terminator_key___!';

  bx = double(transpose(box.by, [1, 0, 2]))
  by = double(transpose(box.bx, [1, 0, 2]))
  bz = double(transpose(box.bz, [1, 0, 2]))

  sz = size(bx)
  returnCode = CALL_EXTERNAL(lib_location, 'mfoNLFFF', parameterMap, sz[1:3], bx, by, bz, $
              abs_field, abs_field_weight, $
              los_projection, los_projection_weight, los_projection_dir_cos, $
              field_component_x, field_component_x_weight, $
              field_component_y, field_component_y_weight, $
              field_component_z, field_component_z_weight, $
              abs_field_max, abs_field_max_weight, $
              los_projection_max, los_projection_max_weight, $
              field_component_x_max, field_component_x_max_weight, $
              field_component_y_max, field_component_y_max_weight, $
              field_component_z_max, field_component_z_max_weight, $
              VALUE = value, /CDECL, /UNLOAD)

  box.bx = transpose(by, [1, 0, 2])
  box.by = transpose(bx, [1, 0, 2])
  box.bz = transpose(bz, [1, 0, 2])
  
  expr = stregex(box.id,'(.+)\.([A-Z]+)',/subexpr,/extract)
  box.id = expr[1] + '.NAS'

  return, returnCode
end
