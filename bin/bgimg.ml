open Js_of_ocaml

module Make() = struct
  let bg_name: string option ref = ref None

  let render (ctx: Dom_html.canvasRenderingContext2D Js.t) x y w h =
    match !bg_name with
      | None -> ()
      | Some name -> Sprite.render ctx name x y w h

  let update name = bg_name := Some name
end
