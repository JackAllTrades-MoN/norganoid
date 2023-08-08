open Ext
open Js_of_ocaml

let audio_context = new%js audioContext
let audios = Hashtbl.create 10

let resume () = audio_context##resume

let load_audio ?(is_loop=true) (name: string) (path: string) cont =
  let e = Dom_html.(createAudio document) in
  e##.src := Js.string path;
  e##.loop := Js.bool is_loop;
  Dom_html.addEventListener e Dom_html.Event.loadstart (Dom_html.handler (fun _ ->
    let source = audio_context##createMediaElementSource e in
    source##connect (audio_context##.destination :> audioNode Js.t);
    Hashtbl.add audios name (e, source);
    cont ();
    Js._false
  )) Js._false |> ignore

let play_audio name =
  let (audio, _) = Hashtbl.find audios name in
  audio##play

let stop_audio () =
  Hashtbl.iter (fun _ ((audio: Dom_html.audioElement Js.t), _) -> audio##pause; audio##.currentTime := 0.) audios

module Rader = struct
  let default_hz = 440.

  module Make() = struct
    let oscillator =
      let o = audio_context##createOscillator in
      o##._type := Js.string "sine";
      o##.frequency##setValueAtTime default_hz audio_context##.currentTime;
      o##connect (audio_context##.destination :> audioNode Js.t);
      o

    let play () = oscillator##start

    let stop () = oscillator##stop

    let set_freq hz =
      oscillator##.frequency##setValueAtTime hz audio_context##.currentTime
  end
end
