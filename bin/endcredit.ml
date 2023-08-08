open Js_of_ocaml
open Scene

let credits = [
  "不穏 written by こっけ";
  "DOVA-SYNDROME https://dova-s.jp/bgm/play8351.html";
  "砂嵐の音・テレビのホワイトノイズ音 written by Causality Sound";
  "DOVA-SYNDROME https://dova-s.jp/se/play836.html"
]

module Make(): SceneType = struct
  let init =
    Mouseup.update_handler (fun _ -> start_scene Title);
    Touchend.update_handler (fun _ -> start_scene Title)

  let render_at_center ctx text size y =
    ctx##.fillStyle := Js.string "rgb(255, 255, 255)";
    ctx##.font := Js.string (Printf.sprintf "%dpx Roboto medium" size);
    ctx##.textBaseline := Js.string "top";
    let cw, _ = Global.canvas_size in
    let cw = float_of_int cw in
    let w = (ctx##measureText (Js.string text))##.width in
    let x = (cw -. w) /. 2. in
    ctx##fillText (Js.string text) x y

  let render_credits ctx y =
    render_at_center ctx "--credits--" 20 y;
    List.iteri (fun i credit ->
      render_at_center ctx credit 20 (y +. 20. +. float_of_int i *. 20.)
    ) credits

  let render () =
    let ctx = Global.context () in
    let _, ch = Global.canvas_size in
    let center = (float_of_int ch -. 20.) /. 2. in
    render_at_center ctx "True end" 40 (center -. 50.);
    render_at_center ctx (Printf.sprintf "最終スコア: %d" !Global.final_score) 30 (center +. 50.);
    render_at_center ctx "最後まで遊んでくれてありがとう" 25 (center +. 100.);
    render_credits ctx (float_of_int ch -. 150.);
    ()

  let update () = ()
end
