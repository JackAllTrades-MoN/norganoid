open Js_of_ocaml
open Interface

let _high_score = ref 0

let get_scene () = match !State.game_state with
  | Title -> (module Title: Scene)
  | Prologue -> (module Prologue : Scene)
  | OnPlaying -> (module Tennis : Scene)
  | GameOver -> (module Gameover : Scene)

let update () =
  let module M = (val get_scene ()) in
  if !State.init_required then begin
    M.init ();
    State.init_required := false
  end;
  M.update ()

let pre_render ctx =
  let w, h = Global.canvas_size in
  let w, h = float_of_int w, float_of_int h in
  ctx##clearRect 0. 0. w h;
  ctx##.fillStyle := Js.string "rgb(0, 0, 0)";
  ctx##fillRect 0. 0. w h;
  ()

let render () =
  let ctx = Global.context () in
  let module M = (val get_scene ()) in
  pre_render ctx;
  ctx##save;
  if not !State.init_required then M.render ();
  ctx##restore

let frame _ =
  update ();
  render ()

let start _ =
  let canvas = Global.canvas () in
  let w, h = Global.canvas_size in
  canvas##.width := w;
  canvas##.height := h;
  Dom_html.addEventListener canvas (Dom_html.Event.mousemove) Mousemove.handler Js._false |> ignore;
  Dom_html.addEventListener canvas (Dom_html.Event.mouseup) Mouseup.handler Js._false |> ignore;
  Dom_html.addEventListener canvas (Dom_html.Event.touchstart) Touchstart.handler Js._false |> ignore;
  Dom_html.addEventListener canvas (Dom_html.Event.touchmove) Touchmove.handler Js._false |> ignore;
  Dom_html.addEventListener canvas (Dom_html.Event.touchend) Touchend.handler Js._false |> ignore;
  ignore @@ Dom_html.window##setInterval (Js.wrap_callback frame) 15.;
  Js._false

let () = Dom_html.window##.onload := Dom_html.handler start
