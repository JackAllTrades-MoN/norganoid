open Js_of_ocaml
open Scene

module Make(): SceneType = struct
  let sec_per_page = 3
  let cnt = ref 0

  let credits = ref [
    [
      "BGM・SE";
      "";
      "【DOVA-SYNDROME】";
      "不穏 written by こっけ";
      "砂嵐の音・テレビのホワイトノイズ音";
      "written by Causality Sound"
    ];
    [
      "製作";
      "";
      "WAFT"
    ];
  ]

  let credit_presented = ref []

  let next () =
    match !credits with
      | [] -> credit_presented := []
      | l::ls ->
        credit_presented := l;
        credits := ls

  let skip _ =
    if List.length !credit_presented > 0 then ()
    else start_scene Title

  let init =
    next ();
    Mouseup.update_handler skip;
    Touchend.update_handler skip

  let render_at_center (ctx: Dom_html.canvasRenderingContext2D Js.t) size text y =
    ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
    ctx##.font := Js.string (Printf.sprintf "%dpx Roboto medium" size);
    ctx##.textBaseline := Js.string "top";
    let cw, _ = Global.canvas_size in
    let cw = float_of_int cw in
    let w = (ctx##measureText (Js.string text))##.width in
    let x = (cw -. w) /. 2. in
    ctx##fillText (Js.string text) x y
    
  let render_credits (ctx: Dom_html.canvasRenderingContext2D Js.t) size lines =
    let _, ch = Global.canvas_size in
    let h = size * (List.length lines) in
    let y = (ch - h) / 2 in
    List.iteri (fun i line ->
      let y = y + i * size in
      render_at_center ctx size line (float_of_int y) 
    ) lines

  let render () =
    let ctx = Global.context () in
    if List.length !credit_presented > 0 then
      render_credits ctx 30 !credit_presented
    else begin
      let (_, ch) = Global.canvas_size in
      let y = float_of_int ch /. 2. -. 100. in
      render_at_center ctx 40 "True end" y;
      render_at_center ctx 30 (Printf.sprintf "最終スコア: %d" !Global.final_score) (y +. 100.);
    end

  let update () =
    cnt := !cnt + 1;
    if !cnt > 60 * sec_per_page then begin
      cnt := 0;
      next ()
    end

end
