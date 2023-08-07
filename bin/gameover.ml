open Global

let _ = print_endline "gameover"

let sprites = Hashtbl.create 10

let render () =
  let open In_canvas in
  let+ (w, h) = use_canvas_size
  and+ ctx = use_context in
  let (w, h) = (float_of_int w, float_of_int h) in
  let noise = Hashtbl.find sprites "noise" in
  Sprite.render ctx noise 0. 0. w h;
  ()

let update () =
  let open In_canvas in
  return (
    let noise = Hashtbl.find sprites "noise" in
    let i = Sprite.next_idx noise in
    let noise = Sprite.(set_idx noise i) in
    Hashtbl.remove sprites "noise";
    Hashtbl.add sprites "noise" noise
  )

let init () =
  let open In_canvas in
  return (
    Audio.play "./audio/noise.mp3";
    Sprite.load "./img/noise.png" (fun noise ->
      let noise = ref noise in
      for i=0 to 4 do
        let x = 800. *. float_of_int i in
        noise := Sprite.add_frame !noise ((x, 0.), (800., 600.))
      done;
      let noise = !noise in
      let noise = Sprite.set_idx noise 0 in
      Hashtbl.add sprites "noise" noise
    ))

