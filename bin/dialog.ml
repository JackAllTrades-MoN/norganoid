open Js_of_ocaml

module Make() = struct

  let margin_w = 80.
  let margin_h = 60.

  let lines_presented = ref []

  let render (ctx: Dom_html.canvasRenderingContext2D Js.t) x y w h =
    (* render_shadow *)
    ctx##.fillStyle := Js.string "rgba(0, 0, 0, 0.5)";
    ctx##fillRect x y w h;
    (* render text *)
    ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
    ctx##.font := Js.string "30px Roboto medium";
    ctx##.textBaseline := Js.string "top";
    let x = x +. margin_w in
    let y = y +. margin_h in
    List.iteri (fun i line ->
      ctx##fillText (Js.string line) x (y +. float_of_int (i * 30))
    ) !lines_presented;
    ()

  let update (ctx: Dom_html.canvasRenderingContext2D Js.t) text cw =
    ctx##save;
    ctx##.font := Js.string "30px Roboto medium";
    ctx##.textBaseline := Js.string "top";
    lines_presented := [];
    let buf = ref "" in
    for i=0 to (String.length text) / 3 - 1 do
      buf := !buf ^ (String.sub text (i*3) 3);
      let w = (ctx##measureText (Js.string !buf))##.width in
      if w >= cw -. margin_w *. 2. then begin
        lines_presented := !buf::!lines_presented;
        buf := ""
      end
    done;
    if String.length !buf > 0 then lines_presented := !buf::!lines_presented;
    lines_presented := List.rev !lines_presented;
    ctx##restore;
    ()
end
