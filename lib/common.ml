open Filename

exception ClassorgException of string

let root_marker = ".classorg_root"
let archive_dir = concat current_dir_name "archive"
let archive_marker = concat archive_dir ".classorg_archive"
let class_marker = ".classorg_class"
let homework_marker = ".classorg_homework"

let touch_empty_file filename =
  let oc = open_out filename in
  close_out oc

let is_initialized () =
  let root_exists = Sys.file_exists root_marker in
  let archive_exists = Sys.file_exists archive_marker in
  if root_exists <> archive_exists then
    ClassorgException "classorg not properly initialized in current directory"
    |> raise
  else root_exists

let check_initialized () =
  match is_initialized () with
  | false -> ClassorgException "classorg is not initialized" |> raise
  | true -> ()
