open Common
open Filename

let main class_name () =
  try
    check_initialized ();
    let class_dir = concat current_dir_name class_name in
    if not (Sys.file_exists class_dir) then Sys.mkdir class_dir 509
    else concat class_dir class_marker |> touch_empty_file
  with e ->
    let msg = Printexc.to_string e in
    Logs.err (fun m -> m "Failed to create class: %s" msg)
