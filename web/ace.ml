
let ace = Jv.get Jv.global "ace"

let edit name = Jv.call ace "edit" [| Jv.of_string name |]

let set_theme editor mode = Jv.call editor "setTheme" [| Jv.of_string mode |]

let set_value editor value = Jv.call editor "setValue" [| Jv.of_string value |]
let get_value editor = Jv.call editor "getValue" [|  |] |> Jv.to_string

let session editor = Jv.get editor "session"

let set_mode editor mode = Jv.call editor "setMode" [| Jv.of_string mode |]
