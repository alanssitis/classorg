open Filename

let root_marker = ".classorg_root"
let archive_dir = concat current_dir_name "archive"
let archive_marker = concat archive_dir ".classorg_archive"

let touch_empty_file filename =
  let oc = open_out filename in
  close_out oc
