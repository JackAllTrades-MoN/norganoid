
module type Scene = sig

  val init : unit -> unit

  val render : unit -> unit

  val update : unit -> unit
end
