let placeholder () = Logs.err (fun m -> m "Not implemented yet")

let setup_log style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

open Cmdliner

let setup_log =
  Term.(const setup_log $ Fmt_cli.style_renderer () $ Logs_cli.level ())

let archive_cmd =
  let doc = "archive doc" in
  let info = Cmd.info "archive" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let create_class_cmd =
  let doc = "create class doc" in
  let info = Cmd.info "class" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let create_homework_cmd =
  let doc = "create homework doc" in
  let info = Cmd.info "homework" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let create_cmd =
  let doc = "create doc" in
  let info = Cmd.info "create" ~doc in
  Cmd.group info [ create_class_cmd; create_homework_cmd ]

let init_cmd =
  let doc = "init doc" in
  let info = Cmd.info "init" ~doc in
  Cmd.v info Term.(const Initialize.main $ setup_log)

let list_cmd =
  let doc = "list doc" in
  let info = Cmd.info "list" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let cmd =
  let doc = "main doc" in
  let info = Cmd.info "classorg" ~version:"0.1" ~doc in
  Cmd.group info [ archive_cmd; create_cmd; init_cmd; list_cmd ]
