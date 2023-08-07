open Js_of_ocaml

let render_title (ctx: Dom_html.canvasRenderingContext2D Js.t) cw ch =
  ctx##save;
  ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
  ctx##.font := Js.string "80px Roboto medium";
  ctx##.textBaseline := Js.string "top";
  let metrics = ctx##measureText (Js.string "NORGANOID" ) in
  let x = (cw -. metrics##.width) /. 2. in
  let y = (ch -. 80.) /. 2. in
  ctx##fillText (Js.string "NORGANOID" ) x y;
  ctx##restore;
  ()

let render_message (ctx: Dom_html.canvasRenderingContext2D Js.t) cw ch =
  ctx##save;
  ctx##.font := Js.string "25px Roboto medium";
  let metrics = ctx##measureText (Js.string "click to play" ) in
  let x = (cw -. metrics##.width) /. 2. in
  let y = (ch -. 80.) /. 2. +. 100. in
  ctx##fillText (Js.string "click to play") x y;
  ctx##restore;
  ()

let render () =
  let ctx = Global.context () in
  let (w, h) = Global.canvas_size in
  let cw, ch = float_of_int w, float_of_int h in
  render_title ctx cw ch;
  render_message ctx cw ch;
  ()

let update () = ()

let init () =
  Mouseup.update_handler (fun _ ->
    Audio.resume () |> ignore;
    Audio.play ~loop:true "./audio/test.mp3";
    State.start Prologue;
  )
