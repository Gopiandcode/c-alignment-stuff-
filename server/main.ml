
let () =
  Dream.run ~port:8081 @@
  Dream.router [
    Dream.get "/static/**" (Dream.static "_build/default/static/");
    Dream.get "/index.html" (Dream.from_filesystem "." "index.html");
    Dream.any "*" (fun req -> Dream.redirect req "/index.html")
  ]
