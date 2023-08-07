open Global

let sprites = Hashtbl.create 10

let render () =
  let open In_canvas in
  let+ w, h = use_canvas_size
  and+ ctx = use_context in
  let cw, ch = float_of_int w, float_of_int h in
  Bgimg.render ctx sprites 0. 0. cw ch;
  Dialog.render ctx 0. 0. cw ch;
  ()

let update () =
  let open In_canvas in
  return ()

let next ctx () =
  match Story.next () with
  | Nop ->
    Audio.pause "./audio/test.mp3";
    State.start OnPlaying;
  | UpdateText line -> Dialog.update ctx line 800.
  | UpdateImage name -> Bgimg.update name

let init () =
  let open In_canvas in
  let+ ctx = use_context in
  Sprite.load "./img/childhood.jpg" (fun childhood ->
    let childhood = Sprite.set_idx childhood 0 in
    let childhood = Sprite.add_frame childhood ((0., 0.), (512., 512.)) in
    Hashtbl.add sprites "childhood" childhood;
    Mouseup.update_handler (fun _ -> next ctx ());
    next ctx ()
  )

