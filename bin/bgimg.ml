open Js_of_ocaml

let _ = print_endline "bgimg"

let bg_name: string option ref = ref None

let render (ctx: Dom_html.canvasRenderingContext2D Js.t) sprites x y w h =
  match !bg_name with
    | None -> ()
    | Some name ->
      let bg = Hashtbl.find sprites name in
      Sprite.render ctx bg x y w h

let update name = bg_name := Some name
