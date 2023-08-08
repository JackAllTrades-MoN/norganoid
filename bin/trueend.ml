open Scene

module Make(): SceneType = struct
  module Bgimg = Bgimg.Make ()
  module Dialog = Dialog.Make ()

  let fetch = Story.(fetch true_end)

  let rec next ctx () =
    match fetch () with
    | Nop ->
      start_scene Endcredit
    | UpdateText line -> Dialog.update ctx line 800.
    | UpdateImage name -> begin
        Bgimg.update name;
        next ctx ()
      end

  let init =
    let ctx = Global.context () in
    Mouseup.update_handler (fun _ -> next ctx ());
    Touchend.update_handler (fun _ -> next ctx ());
    next ctx ()

  let render () =
    let ctx = Global.context () in
    let w, h = Global.canvas_size in
    let cw, ch = float_of_int w, float_of_int h in
    Bgimg.render ctx 0. 0. cw ch;
    Dialog.render ctx 0. 0. cw ch;
    ()

  let update () = ()
end
