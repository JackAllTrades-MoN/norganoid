open Js_of_ocaml
open Scene

module Make(): SceneType = struct
  module Rader = Audio.Rader.Make ()
  let score = ref 0
  let balls = ref []
  let bar = ref (Bar.create ())
  let ball_presented = ref true

  let init =
    Rader.play ();
    balls := [(Ball.gen 800. ())];
    Mousemove.update_handler (fun e ->
      let (_, y) = !bar.position in
      bar := Bar.update_position (float_of_int e##.offsetX) y !bar
    );
    Touchmove.update_handler (fun e ->
      let canvas = Global.canvas () in
      let (_, y) = !bar.position in
      let actual_w = canvas##.offsetWidth in
      let logical_w = canvas##.width in
      print_endline @@ Printf.sprintf "actual_w: %d, logical_w: %d" actual_w logical_w;
      let a = float_of_int logical_w /. float_of_int actual_w in
      let actual_offset = canvas##getBoundingClientRect##.left |> int_of_float in
      let actual_x = (e##.changedTouches##item 0 |> Js.Optdef.to_option |> Option.get)##.clientX - actual_offset in
      let logical_x = (float_of_int actual_x) *. a in
      print_endline @@ Printf.sprintf "actual: %d, logical: %f" actual_x logical_x;
      bar := Bar.update_position logical_x y !bar
    )

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

  let end_game () =
    if !score < 100 then start_scene GameOver
    else start_scene Normalend

  let update () =
    if List.exists Ball.(fun ball ->
      let (_, by) = ball.position in
      510. <= by
    ) !balls then begin
      Rader.stop ();
      end_game ()
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
    Rader.set_freq (440. +. nd *. 300.)

end