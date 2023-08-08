
type game_state =
  | Title
  | Prologue
  | OnPlaying
  | GameOver

let game_state = ref Title

let init_required = ref true

let start new_state =
  Mousemove.update_handler (fun _ -> ());
  Mouseup.update_handler (fun _ -> ());
  game_state := new_state;
  init_required := true
