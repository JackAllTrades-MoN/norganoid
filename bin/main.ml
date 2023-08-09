open Scene
open Js_of_ocaml

let scene_buf: (module SceneType) option ref = ref None

let current_scene () =
  if Option.is_some !next_scene then begin
    Audio.stop_audio ();
    Mousemove.update_handler (fun _ -> ());
    Mouseup.update_handler (fun _ -> ());
    Touchend.update_handler (fun _ -> ());
    Touchmove.update_handler (fun _ -> ());
    Touchstart.update_handler (fun _ -> ())
  end;
  let next = !next_scene |> Option.map (function
    | Logo -> (module Logo.Make(): SceneType)
    | Title -> (module Title.Make())
    | Prologue -> (module Prologue.Make())
    | OnPlaying -> (module Tennis.Make())
    | GameOver -> (module Gameover.Make())
    | Normalend -> (module Normalend.Make())
    | Trueend -> (module Trueend.Make())
    | Endcredit -> (module Endcredit.Make())
  ) in
  if Option.is_some next then begin
    scene_buf := next;
    next_scene := None;
  end;
  Option.get !scene_buf

let update () =
  let module M = (val current_scene ()) in
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
  let module M = (val current_scene ()) in
  pre_render ctx;
  ctx##save;
  M.render ();
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
  Sprite.load
    "waft_logo"
    "./img/waft_logo.png"
    ~frames:[|((0., 0.), (242., 112.))|] (fun _ ->
  Sprite.load
    "childhood_blur"
    "./img/childhood_blur.jpg"
    ~frames:[|((0., 0.), (512., 512.))|] (fun _ ->
  Sprite.load
      "myson"
      "./img/boy.jpg"
      ~frames:[|((0., 0.), (512., 512.))|] (fun _ ->
  Sprite.load
      "myson_blur"
      "./img/boy_blur.jpg"
      ~frames:[|(0., 0.), (512., 512.)|] (fun _ ->
  Sprite.load "noise" "./img/noise.png" (fun _ ->
  for i=0 to 4 do
    let x = 800. *. float_of_int i in
    Sprite.add_frame "noise" ((x, 0.), (800., 600.))
  done;
  Audio.load_audio "prologue" "./audio/test.mp3" (fun _ ->
  Audio.load_audio "noise" "./audio/noise.mp3" (fun _ ->
    ignore @@ Dom_html.window##setInterval (Js.wrap_callback frame) 15.;
  )))))));
  Js._false

let () = Dom_html.window##.onload := Dom_html.handler start
