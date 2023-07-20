open Bos
open Lwt.Syntax

module JS = Yojson.Safe.Util

let tmp_file = Bos.OS.File.tmp "compile_%s.c" |> Result.get_ok
let tmp_out_file = Bos.OS.File.tmp "compile_%s.c" |> Result.get_ok

let compile_and_run program =
  Result.get_ok (OS.File.write tmp_file program);
  let compile_output, (_, status) = 
    OS.Cmd.run_out ~err:OS.Cmd.err_run_out Cmd.(v "gcc" % p tmp_file % "-o" % p tmp_out_file)
    |> OS.Cmd.out_string
    |> Result.get_ok in
  match status with
  | `Exited 0 ->
    let output, _ =
      OS.Cmd.run_out ~err:OS.Cmd.err_run_out Cmd.(v (p tmp_out_file))
      |> OS.Cmd.out_string
      |> Result.get_ok in
    Yojson.Safe.to_string (`Assoc [
      "compiled", `Bool true;
      "output", `String output
    ])
  | _ ->
    Yojson.Safe.to_string (`Assoc [
      "compiled", `Bool false;
      "output", `String compile_output
    ])

let enforce_prelude prog =
{|#include <stdio.h>
#include <stdlib.h>
|} ^ prog

let run_program : Dream.client Dream.message -> Dream.response Lwt.t =
  fun req ->
  let* body = Dream.body req in
  let body = Yojson.Safe.from_string body in
  let prog = JS.member "program" body |> JS.to_string |> enforce_prelude in

  let result = compile_and_run prog in
  Dream.respond (result)

let () =
  Dream.run ~port:8081 @@
  Dream.router [
    Dream.get "/static/**" (Dream.static "_build/default/static/");
    Dream.get "/index.html" (Dream.from_filesystem "." "index.html");
    Dream.post "/run" run_program;
    Dream.any "*" (fun req -> Dream.redirect req "/index.html")
  ]
