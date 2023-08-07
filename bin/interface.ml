open Global

module type Scene = sig

  val init : unit -> unit In_canvas.t

  val render : unit -> unit In_canvas.t

  val update : unit -> unit In_canvas.t
end