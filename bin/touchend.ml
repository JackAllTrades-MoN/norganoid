open Js_of_ocaml

let f = ref (fun _e -> ())

let update_handler g = f := g

let handler: (Dom_html.canvasElement Js.t, _) Dom.event_listener = 
  Dom_html.handler (fun (e: Dom_html.touchEvent Js.t) ->
  !f e;
  Js._false
)
