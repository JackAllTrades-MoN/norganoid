open Scene

module Make(): SceneType = struct
  let tick = ref 0
  let sec = ref 0
  let sprites = Hashtbl.create 10

  let init =
    Audio.play_audio "noise";
    Sprite.load "./img/noise.png" (fun noise ->
      let noise = ref noise in
      for i=0 to 4 do
        let x = 800. *. float_of_int i in
        noise := Sprite.add_frame !noise ((x, 0.), (800., 600.))
      done;
      let noise = !noise in
      let noise = Sprite.set_idx noise 0 in
      Hashtbl.add sprites "noise" noise
    )

  let render () =
    let ctx = Global.context () in
    let w, h = Global.canvas_size in
    let (w, h) = (float_of_int w, float_of_int h) in
    Hashtbl.find_opt sprites "noise"
    |> Option.iter (fun noise ->
      Sprite.render ctx noise 0. 0. w h
    )


  let update () =
    if !sec >= 5 then start_scene Title
    else begin
      Hashtbl.find_opt sprites "noise"
      |> Option.iter (fun noise ->
        let i = Sprite.next_idx noise in
        let noise = Sprite.(set_idx noise i) in
        Hashtbl.remove sprites "noise";
        Hashtbl.add sprites "noise" noise;
        tick := (!tick + 1) mod Int.max_int;
        if !tick mod 60 = 0 then sec := !sec + 1
      )
    end

end
