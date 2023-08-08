

module Js_of_ocaml: sig
  include module type of struct include Js_of_ocaml end

  class type audioNode = object
    method connect : audioNode Js.t -> unit Js.meth
  end

  and audioParam = object
    inherit audioNode
    method defaultValue : float Js.readonly_prop
    method value : float Js.prop
  
    method cancelScheduledValues : float -> unit Js.meth
    method exponentialRampToValueAtTime : float -> float -> unit Js.meth
    method linearRampToValueAtTime : float -> float -> unit Js.meth
    method setTargetAtTime : float -> float -> float -> unit Js.meth
    method setValueAtTime : float -> float -> unit Js.meth
    method setValueCurveAtTime :
      Typed_array.float32Array Js.t -> float -> float -> unit Js.meth
  end

  and periodicWave = object
  end

  and virtual baseAudioContext = object
    method currentTime : float Js.readonly_prop
    method destination : audioDestinationNode Js.t Js.readonly_prop
    method resume : unit Js.meth
    method createMediaElementSource :
      Dom_html.mediaElement Js.t -> mediaElementSourceNode Js.t Js.meth
    method createOscillator : oscillatorNode Js.t Js.meth
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

  and oscillatorNode = object ('self)
    inherit audioNode

    method detune : audioParam Js.t Js.prop
    method frequency : audioParam Js.t Js.prop
    method _type : Js.js_string Js.t Js.prop

    method start : unit Js.meth
    method stop : unit Js.meth

    method setPeriodicWave : periodicWave Js.t -> unit Js.meth

    method onended :
      ('self Js.t, 'self Dom.event Js.t) Dom.event_listener Js.writeonly_prop
  end

  val audioContext : audioContext Js.t Js.constr

  val getMediaElementById : string -> Dom_html.mediaElement Js.t

end = struct
  include Js_of_ocaml

  class type audioNode = object
    method connect : audioNode Js.t -> unit Js.meth
  end

  and audioParam = object
    inherit audioNode
    method defaultValue : float Js.readonly_prop
    method value : float Js.prop
  
    method cancelScheduledValues : float -> unit Js.meth
    method exponentialRampToValueAtTime : float -> float -> unit Js.meth
    method linearRampToValueAtTime : float -> float -> unit Js.meth
    method setTargetAtTime : float -> float -> float -> unit Js.meth
    method setValueAtTime : float -> float -> unit Js.meth
    method setValueCurveAtTime :
      Typed_array.float32Array Js.t -> float -> float -> unit Js.meth
  end

  and periodicWave = object
  end

  and virtual baseAudioContext = object
    method currentTime : float Js.readonly_prop
    method destination : audioDestinationNode Js.t Js.readonly_prop
    method resume : unit Js.meth
    method createMediaElementSource :
      Dom_html.mediaElement Js.t -> mediaElementSourceNode Js.t Js.meth
    method createOscillator : oscillatorNode Js.t Js.meth
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

  and oscillatorNode = object ('self)
    inherit audioNode

    method detune : audioParam Js.t Js.prop
    method frequency : audioParam Js.t Js.prop
    method _type : Js.js_string Js.t Js.prop

    method start : unit Js.meth
    method stop : unit Js.meth

    method setPeriodicWave : periodicWave Js.t -> unit Js.meth

    method onended :
      ('self Js.t, 'self Dom.event Js.t) Dom.event_listener Js.writeonly_prop
  end

  let audioContext =
    Js.Optdef.get
      (Js.Unsafe.global##._AudioContext)
      (fun () -> Js.Unsafe.global##.webkitAudioContext)

  let getMediaElementById id =
    Dom_html.getElementById id |> Js.Unsafe.coerce

end
