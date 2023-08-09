open Js_of_ocaml
open Scene

let sec_logo_shown = 3;

module Make() : SceneType = struct
  let clock = ref 0

  let start _ =
    Audio.resume ();    
    start_scene Title

  let init =
    Mouseup.update_handler start;
    Touchend.update_handler start

  let render_filter ctx w h =
    let a = sec_logo_shown * 60 / 2 in
    let t = Int.max (Int.abs (!clock - a) - 40) 0 in
    let k = a - 40 in
    let alpha = float_of_int t /. float_of_int k in
    ctx##.fillStyle := Js.string (Printf.sprintf "rgba(0, 0, 0, %f)" alpha);
    ctx##fillRect 0. 0. w h

  let render () =
    let ctx = Global.context () in
    let (w, h) = Global.canvas_size in
    let cw, ch = float_of_int w, float_of_int h in
    let (w, h) = Sprite.size_of "waft_logo" in
    let x = (cw -. w) /. 2. in
    let y = (ch -. h) /. 2. in
    Sprite.render ctx "waft_logo" x y w h;
    render_filter ctx cw ch;
    ()

  let update () =
    if !clock > sec_logo_shown * 60 then start_scene Title
    else clock := (!clock + 1) mod Int.max_int;

end