open Scene

module Make(): SceneType = struct
  module Bgimg = Bgimg.Make ()
  module Dialog = Dialog.Make ()

  let sprites = Hashtbl.create 10

  let fetch = Story.(fetch true_end)

  let rec next ctx () =
    match fetch () with
    | Nop ->
      start_scene Title
    | UpdateText line -> Dialog.update ctx line 800.
    | UpdateImage name -> begin
        Bgimg.update name;
        next ctx ()
      end

  let init =
    let ctx = Global.context () in
    Sprite.load "./img/childhood.jpg" (fun childhood ->
      let childhood = Sprite.set_idx childhood 0 in
      let childhood = Sprite.add_frame childhood ((0., 0.), (512., 512.)) in
      Hashtbl.add sprites "childhood" childhood;
      Mouseup.update_handler (fun _ -> next ctx ());
      Touchend.update_handler (fun _ -> next ctx ());
      next ctx ()
    )

  let render () =
    let ctx = Global.context () in
    let w, h = Global.canvas_size in
    let cw, ch = float_of_int w, float_of_int h in
    Bgimg.render ctx sprites 0. 0. cw ch;
    Dialog.render ctx 0. 0. cw ch;
    ()

  let update () = ()
end
