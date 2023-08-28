open Common
open Filename

let hw_tex_file_template class_name hw_name =
  "\\documentclass{article}\n\
   \\usepackage[utf8]{inputenc}\n\
   \\usepackage[scr]{rsfso}\n\
   \\usepackage{amsfonts}\n\
   \\usepackage{amsmath}\n\
   \\usepackage{amssymb}\n\
   \\usepackage{amsthm}\n\
   \\usepackage{booktabs}\n\
   \\usepackage{color}\n\
   \\usepackage{enumitem}\n\
   \\usepackage{float}\n\
   \\usepackage{fullpage}\n\
   \\usepackage{geometry}\n\
   \\usepackage{graphicx}\n\
   \\usepackage{mathpartir}\n\
   \\usepackage{multirow}\n\
   \\usepackage{newpxtext,newpxmath}\n\
   \\usepackage{tabularx}\n\
   \\usepackage{tikz}\n\
   \\usetikzlibrary{calc, automata, positioning, arrows}\n\n\
   \\newcounter{problemcounter}\n\n\
   \\newcommand{\\problem}[1][]{\\stepcounter{problemcounter}\\section*{Problem \
   \\theproblemcounter #1}\\vspace{-1em}\\rule{\\textwidth}{1pt}\n\
  \        \\vspace{.25em}\n\
   }\n\n\
   \\newcommand{\\equivalence}[2]{#1 & \\Leftrightarrow & #2}\n\n\
   \\newcommand{\\red}[1]{{\\color{red} #1}}\n\n\
   \\newcommand{\\blank}[1]{\\red{#1}}\n\n"
  ^ Printf.sprintf "\\title{%s %s}" class_name hw_name
  ^ "\n\
     \\author{Alan Chung Ma}\n\
     \\date{}\n\n\
     \\begin{document}\n\n\
     \\maketitle\n\n\
     [Collaborations]\n\n\
     \\end{document}\n"

let create_hw_tex_file class_name hw_name path =
  if Sys.file_exists path then
    ClassorgException (Printf.sprintf "%s already exists" path) |> raise
  else
    let oc = open_out path in
    hw_tex_file_template class_name hw_name |> Printf.fprintf oc "%s";
    close_out oc

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
      else (
        touch_empty_file hw_marker;
        let hw_file = homework ^ ".tex" |> concat hw_dir in
        if Sys.file_exists hw_file then
          Logs.err (fun m -> m "%s already exists" hw_file)
        else create_hw_tex_file class_name homework hw_file)
  with e ->
    let msg = Printexc.to_string e in
    Logs.err (fun m -> m "Failed to create homework: %s" msg)
