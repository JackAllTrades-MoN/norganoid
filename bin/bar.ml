open Js_of_ocaml

let _ = print_endline "bar"

type t = {
  size: float * float;
  position: float * float;
}

let create () = {
  size=(100., 10.);
  position=(400., 500.)
}

let render (ctx: Dom_html.canvasRenderingContext2D Js.t) t =
  let (x, y) = t.position in
  let (w, h) = t.size in
  ctx##save |> ignore;
  ctx##.fillStyle := Js.string "white";
  ctx##fillRect x y w h;
  ctx##restore

let update_position cx y t =
  let (w, _) = t.size in
  let position = (cx -. w /. 2., y) in
  {t with position}

let is_hit (ball: Ball.t) t =
  let r = ball.r in
  let (lx, ly) = t.position in
  let (w, _) = t.size in
  let (rx, ry) = (lx +. w, ly) in
  let (bx, by) = ball.position in
  let is_in_l =
    let (vx, vy) = (lx -. bx, ly -. by) in
    let d = vx *. vx +. vy *. vy in
    d <= 4. *. r *. r
  in
  let is_in_r =
    let (vx, vy) = (rx -. bx, ry -. by) in
    let d = vx *. vx +. vy *. vy in
    d <= 4. *. r *. r
  in
  let is_in_center = lx <= bx && bx <= rx && ly <= by && by <= ry in
  is_in_l || is_in_r || is_in_center
