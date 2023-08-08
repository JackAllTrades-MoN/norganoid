open Js_of_ocaml

let pi = 4.0 *. atan 1.0;;

type t = {
  r: float;
  position: float * float;
  velocity: float * float;
}

let gen cw () =
  let r = 5. in
  let position = [|(0., 0.); ((cw -. r) /. 2., 0.); (cw -. r, 0.)|].(Random.int 3) in
  let velocity = (2., 2.) in
  print_endline @@ Printf.sprintf
    "(x, y, vx, vy) = (%f, %f, %f, %f)"
    (fst position) (snd position) (fst velocity) (snd velocity);
  { r; position; velocity }

let update t =
  let (x, y) = t.position in
  let (vx, vy) = t.velocity in
  let vx = if x +. vx <= 0. || x +. vx >= 800. then (-.vx) else vx in
  let vy = if y +. vy <= 0. || y +. vy >= 600. then (-.vy) else vy in
  {t with position = (x +. vx, y +. vy); velocity = (vx, vy)}

let render (ctx: Dom_html.canvasRenderingContext2D Js.t) t =
  let (x, y) = t.position in
  ctx##save;
  ctx##.fillStyle := Js.string "white";
  ctx##beginPath;
  ctx##arc x y t.r 0. (2. *. pi) Js._false;
  ctx##fill;
  ctx##restore |> ignore

let reflect t =
  let (vx, vy) = t.velocity in {t with velocity = (vx, -.vy)}
