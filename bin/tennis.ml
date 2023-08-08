open Js_of_ocaml

let score = ref 0
let balls = ref []
let bar = ref (Bar.create ())
let ball_presented = ref true

let render_score (ctx: Dom_html.canvasRenderingContext2D Js.t) =
  ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
  ctx##.font := Js.string "30px Roboto medium";
  ctx##.textBaseline := Js.string "top";
  ctx##fillText (Js.string (Printf.sprintf "Score: %d" !score)) 0. 0.;
  ()

let render () =
  let ctx = Global.context () in
  Bar.render ctx !bar;
  if !ball_presented then List.iter (fun ball -> Ball.render ctx ball) !balls;
  render_score ctx;
  ()

let update () =
  if List.exists Ball.(fun ball ->
    let (_, by) = ball.position in
    510. <= by
  ) !balls then begin
    Audio.Rader.stop ();
    State.start GameOver
  end;
  balls := List.map (fun ball ->
    let ball = if Bar.is_hit ball !bar then begin
      score := !score + 10;
      Ball.reflect ball
    end else ball in
    Ball.update ball
  ) !balls;
  if !score > 50 then ball_presented := false;
  (*if List.length !balls <= !score / 50 then
    balls := (Ball.gen 800. ())::!balls;*)
  let ball = List.hd !balls in
  let x, _ = Ball.(ball.position) in
  let bar_x, _ = Bar.(!bar.position) in
  let d = x -. bar_x in
  let nd = d /. 400. in
  Audio.Rader.set_freq (440. +. nd *. 300.)

let init () =
  Audio.Rader.play ();
  balls := [(Ball.gen 800. ())];
  Mousemove.update_handler (fun e ->
    let (_, y) = !bar.position in
    bar := Bar.update_position (float_of_int e##.offsetX) y !bar
  )
