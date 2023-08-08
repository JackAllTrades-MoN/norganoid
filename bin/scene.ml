
module type SceneType = sig
  val init : unit

  val render : unit -> unit

  val update : unit -> unit
end

type scene_name =
  | Title
  | Prologue
  | OnPlaying
  | GameOver
  | Normalend
  | Trueend
  | Endcredit

let next_scene = ref (Some Title)

let start_scene name = next_scene := Some name

