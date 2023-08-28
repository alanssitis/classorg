open Common
open Filename

let main class_name homework () =
  try
    check_initialized ();
    let class_dir = concat current_dir_name class_name in
    let class_marker = concat class_dir class_marker in
    if not (Sys.file_exists class_marker) then
      Logs.err (fun m -> m "Class %s not initialized by classorg" class_name)
    else
      let hw_dir = concat class_dir homework in
      if not (Sys.file_exists hw_dir) then Sys.mkdir hw_dir 509;
      let hw_marker = concat hw_dir homework_marker in
      if Sys.file_exists hw_marker then
        Logs.err (fun m ->
            m "classorg has already initialized %s for %s" homework class_name)
      else touch_empty_file hw_marker;
      let hw_file = homework ^ ".tex" |> concat hw_dir in
      if Sys.file_exists hw_file then
        Logs.err (fun m -> m "%s already exists" hw_file)
  with e ->
    let msg = Printexc.to_string e in
    Logs.err (fun m -> m "Failed to create homework: %s" msg)
