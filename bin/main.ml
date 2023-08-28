let main () = Cmdliner.Cmd.eval Classorg.Commands.cmd |> exit
let () = main ()
