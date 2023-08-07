open Js_of_ocaml

type pos = float * float
type size = float * float

type t = {
  img: Dom_html.imageElement Js.t;
  frames: (pos * size) Array.t;
  idx: int;
}

type sprites = (String.t, t) Hashtbl.t

let _load name k =
  let img = Dom_html.createImg Dom_html.document in
  img##.src := Js.string name;
  img##.onload := Dom_html.handler (fun _ -> k img; Js._false)

let load name k = _load name (fun img -> k {img; frames=[||]; idx=(-1)})

let add_frame t frame = {t with frames = Array.append t.frames [|frame|] }

let set_idx t idx = {t with idx}

let next_idx t = (t.idx + 1) mod Array.length t.frames

let render ctx t x y w h =
  let (sx, sy), (sw, sh) = t.frames.(t.idx) in
  ctx##drawImage_full t.img sx sy sw sh x y w h

let size_of t =
  let (_, size) = t.frames.(t.idx) in
  size