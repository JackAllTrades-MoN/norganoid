open Js_of_ocaml
open Interface

let _high_score = ref 0

let get_scene () = match !State.game_state with
  | Title -> (module Title: Scene)
  | Prologue -> (module Prologue : Scene)
  | OnPlaying -> (module Tennis : Scene)
  | GameOver -> (module Gameover : Scene)

let update =
  let open Global.In_canvas in
  let module M = (val get_scene ()) in
  let+ _ = return () in
  let init = if !State.init_required then (
    State.init_required := false;
    M.init()
  ) else return () in
  init >> M.update ()

let clear ctx w h =
  let w, h = float_of_int w, float_of_int h in
  ctx##clearRect 0. 0. w h;
  ()

let render_bg ctx w h =
  let w, h = float_of_int w, float_of_int h in
  ctx##save;
  ctx##.fillStyle := Js.string "rgb(0, 0, 0)";
  ctx##fillRect 0. 0. w h;
  ctx##restore;
  ()

let render_body =
  let open Global.In_canvas in
  let* _ = return () in
  let module M = (val get_scene ()) in
  if not !State.init_required
  then M.render ()
  else return ()

let render =
  let open Global.In_canvas in
  let* ctx = use_context
  and+ w, h = use_canvas_size in
  (return @@ clear ctx w h)
  >> (return @@ render_bg ctx w h)
  >> render_body

let frame = Global.In_canvas.(update >> render) 

let start _ =
  Global.In_canvas.run "canvas-main" frame;
  Js._false

let () = Dom_html.window##.onload := Dom_html.handler start
