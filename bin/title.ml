open Js_of_ocaml

let clock = ref 0
let show_msg = ref true

let render_title (ctx: Dom_html.canvasRenderingContext2D Js.t) cw ch =
  ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
  ctx##.font := Js.string "80px Roboto medium";
  ctx##.textBaseline := Js.string "top";
  let metrics = ctx##measureText (Js.string "NORGANOID" ) in
  let x = (cw -. metrics##.width) /. 2. in
  let y = (ch -. 80.) /. 2. in
  ctx##fillText (Js.string "NORGANOID" ) x y;
  ()

let render_message (ctx: Dom_html.canvasRenderingContext2D Js.t) cw ch =
  let text = "click to play" in
  ctx##.font := Js.string "25px Roboto medium";
  let metrics = ctx##measureText (Js.string text ) in
  let x = (cw -. metrics##.width) /. 2. in
  let y = (ch -. 80.) /. 2. +. 100. in
  ctx##fillText (Js.string text) x y;
  ()

let render_warning (ctx: Dom_html.canvasRenderingContext2D Js.t) cw ch =
  let text = "※音を使用するコンテンツです" in
  ctx##.fillStyle := Js.string "rgb(255, 0, 0)";
  ctx##.font := Js.string "25px Yomogi, cursive";
  let metrics = ctx##measureText (Js.string text ) in
  let x = (cw -. metrics##.width) /. 2. in
  let y = (ch -. 80.) /. 2. +. 200. in
  ctx##fillText (Js.string text) x y;
  ()

let render () =
  let ctx = Global.context () in
  let (w, h) = Global.canvas_size in
  let cw, ch = float_of_int w, float_of_int h in
  render_title ctx cw ch;
  if !show_msg then render_message ctx cw ch;
  render_warning ctx cw ch;
  ()

let update () =
  clock := (!clock + 1) mod Int.max_int;
  if !clock mod 60 = 0 then show_msg := not !show_msg

let init () =
  let f _ =
    Audio.resume () |> ignore;
    Audio.play ~loop:true "./audio/test.mp3";
    State.start Prologue;
  in
  Mouseup.update_handler f;
  Touchend.update_handler f
