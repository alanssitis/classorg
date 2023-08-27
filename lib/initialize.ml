open Common

exception InitializeException of string

let is_initialized () =
  let root_exists = Sys.file_exists root_marker in
  let archive_exists = Sys.file_exists archive_marker in
  if root_exists <> archive_exists then
    raise
      (InitializeException
         "classorg not properly initialized in current directory")
  else root_exists

let main () =
  try
    match is_initialized () with
    | true ->
        Logs.warn (fun m ->
            m "classorg was already initialized in current directory")
    | false ->
        touch_empty_file root_marker;
        if not (Sys.file_exists archive_dir) then Sys.mkdir archive_dir 509;
        touch_empty_file archive_marker
  with e ->
    let msg = Printexc.to_string e in
    Logs.err (fun m -> m "Failed in initialize: %s" msg)
