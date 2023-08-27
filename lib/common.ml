let root = "./.classorg_root"
let archive = "./archive/.classorg_archive"

let touch_empty_file filename =
  let oc = open_out filename in
  close_out oc
