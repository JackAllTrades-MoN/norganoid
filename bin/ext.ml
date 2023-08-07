

module Js_of_ocaml: sig
  include module type of struct include Js_of_ocaml end

  class type audioNode = object
    method connect : audioNode Js.t -> unit Js.meth
  end

  and virtual baseAudioContext = object
    method destination : audioDestinationNode Js.t Js.readonly_prop
    method resume : unit Js.meth
    method createMediaElementSource :
      Dom_html.mediaElement Js.t -> mediaElementSourceNode Js.t Js.meth
  end

  and audioDestinationNode = object
    inherit audioNode
    method maxChannelCount : int Js.readonly_prop
  end

  and audioContext = object
    inherit baseAudioContext
    method close : unit Js.meth
  end

  and mediaElementSourceNode = object
    inherit audioNode
  end

  val audioContext : audioContext Js.t Js.constr

  val getMediaElementById : string -> Dom_html.mediaElement Js.t

end = struct
  include Js_of_ocaml

  class type audioNode = object
    method connect : audioNode Js.t -> unit Js.meth
  end

  and virtual baseAudioContext = object
    method destination : audioDestinationNode Js.t Js.readonly_prop
    method resume : unit Js.meth
    method createMediaElementSource :
      Dom_html.mediaElement Js.t -> mediaElementSourceNode Js.t Js.meth
  end

  and audioDestinationNode = object
    inherit audioNode
    method maxChannelCount : int Js.readonly_prop
  end

  and audioContext = object
    inherit baseAudioContext
    method close : unit Js.meth
  end

  and mediaElementSourceNode = object
    inherit audioNode
  end

  let audioContext =
    Js.Optdef.get
      (Js.Unsafe.global##._AudioContext)
      (fun () -> Js.Unsafe.global##.webkitAudioContext)

  let getMediaElementById id =
    Dom_html.getElementById id |> Js.Unsafe.coerce

end
