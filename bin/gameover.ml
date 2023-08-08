open Scene

module Make(): SceneType = struct
  let tick = ref 0
  let sec = ref 0

  let init =
    Audio.play_audio "noise"

  let render () =
    let ctx = Global.context () in
    let w, h = Global.canvas_size in
    let (w, h) = (float_of_int w, float_of_int h) in
    Sprite.render ctx "noise" 0. 0. w h

  let update () =
    if !sec >= 5 then start_scene Title
    else begin
      let i = Sprite.next_idx "noise" in
      Sprite.set_idx "noise" i;
      tick := (!tick + 1) mod Int.max_int;
      if !tick mod 60 = 0 then sec := !sec + 1
    end

end
