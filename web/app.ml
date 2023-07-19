[@@@warning "-33"]
open! Bonsai_web


let component =
  Bonsai.const begin
    Vdom.Node.div ~attr:(Vdom.Attr.class_ "grid-container") [
      Vdom.Node.div ~attr:Vdom.Attr.(class_ "grid-x" @ class_ "grid-margin-x") [
        Vdom.Node.div ~attr:Vdom.Attr.(class_ "cell" @ class_ "small-4") [Vdom.Node.text "Hello world!"];
        Vdom.Node.div ~attr:Vdom.Attr.(class_ "cell" @ class_ "small-4") [Vdom.Node.text "Hello world!"];
        Vdom.Node.div ~attr:Vdom.Attr.(class_ "cell" @ class_ "small-4") [Vdom.Node.text "Hello world!"];
      ]]
  end

let _ =
  Bonsai_web.Start.start Start.Result_spec.just_the_view
    ~bind_to_element_with_id:"app"
    component

