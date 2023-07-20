open Brr

let run_program program =
  let init =
    Brr_io.Fetch.Request.init
      ~body:(Brr_io.Fetch.Body.of_jstr (Json.encode (Jv.obj [|
        "program", Jv.of_string program
      |])))
      ~method':(Jstr.v "POST")
      () in
  Fut.bind (Brr_io.Fetch.url ~init (Jstr.v "/run")) (fun resp ->
    resp
    |> Result.get_ok
    |> Brr_io.Fetch.Response.as_body 
    |> Brr_io.Fetch.Body.text
    |> Fut.map (fun v -> Jstr.to_string (Result.get_ok v))
  )

