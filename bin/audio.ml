open Ext
open Js_of_ocaml

let _ = print_endline "audio"

let audio_context =
  print_endline "try to get audio context";
  let audio_context = new%js audioContext in
  print_endline "succeeded";
  audio_context

let sources = Hashtbl.create 10

let resume () = audio_context##resume

let load_audio is_loop name cont =
  let e = Dom_html.(createAudio document) in
  e##.src := Js.string name;
  e##.loop := Js.bool is_loop;
  Dom_html.addEventListener e Dom_html.Event.loadstart (Dom_html.handler (fun _ ->
    let source = audio_context##createMediaElementSource e in
    cont (e, source);
    Js._false
  )) Js._false |> ignore

let play ?(loop = false) name =
  match Hashtbl.find_opt sources name with
    | None ->
      load_audio loop name (fun (audio, source) ->
        source##connect (audio_context##.destination :> audioNode Js.t) |> ignore;
        Hashtbl.add sources name (audio, source);
        audio##play)
    | Some (audio, _) ->
      audio##play

let pause name =
  let audio, _ = Hashtbl.find sources name in
  audio##pause

module Rader = struct
  let default_hz = 440.

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