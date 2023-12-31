let placeholder () = Logs.err (fun m -> m "Not implemented yet")

let setup_log style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

open Cmdliner

let setup_log =
  Term.(const setup_log $ Fmt_cli.style_renderer () $ Logs_cli.level ())

let class_name =
  let doc = "Name of the class" in
  Arg.(required & pos 0 (Arg.some Arg.string) None & info [] ~doc ~docv:"CLASS")

let homework =
  let doc = "Homework number" in
  Arg.(
    required & pos 1 (Arg.some Arg.string) None & info [] ~doc ~docv:"HOMEWORK")

let archive_cmd =
  let doc = "Archive classes." in
  let info = Cmd.info "archive" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let create_class_cmd =
  let doc = "Create a new class workspace." in
  let info = Cmd.info "class" ~doc in
  Cmd.v info Term.(const Create_class.main $ class_name $ setup_log)

let create_homework_cmd =
  let doc = "Create a new homework space. Default is a LaTeX assignment." in
  let info = Cmd.info "homework" ~doc in
  Cmd.v info
    Term.(const Create_homework.main $ class_name $ homework $ setup_log)

let create_cmd =
  let doc = "Create new workspace or homeworks." in
  let info = Cmd.info "create" ~doc in
  Cmd.group info [ create_class_cmd; create_homework_cmd ]

let init_cmd =
  let doc = "Initialize current directory with classorg." in
  let info = Cmd.info "init" ~doc in
  Cmd.v info Term.(const Initialize.main $ setup_log)

let list_cmd =
  let doc = "List all current active classes." in
  let info = Cmd.info "list" ~doc in
  Cmd.v info Term.(const placeholder $ setup_log)

let cmd =
  let doc = "An opinionated class homework management tool." in
  let info = Cmd.info "classorg" ~version:"0.1" ~doc in
  let default = Term.const (`Help (`Pager, None)) |> Term.ret in
  Cmd.group ~default info [ archive_cmd; create_cmd; init_cmd; list_cmd ]
