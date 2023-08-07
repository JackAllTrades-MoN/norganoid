
type game_state =
  | Title
  | Prologue
  | OnPlaying
  | GameOver

let game_state = ref Title

let init_required = ref true

let start new_state =
  game_state := new_state;
  init_required := true
