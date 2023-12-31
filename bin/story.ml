type command =
  | Nop
  | UpdateText of string
  | UpdateImage of string

let t text = UpdateText text
let i image = UpdateImage image

let prologue = [|
  t "大人になるにつれて、子供の頃の記憶というのは薄れていく。";
  t "少なくとも僕にとってはそうだった。";
  i "childhood_blur";
  t "両親に連れられて訪れた、あの動物園の名前はなんだったか。";
  t "幼稚園で密かに募らせた幼い恋心";
  t "大好きだったあの先生の名前すら、もはや思い出せはしない。";
  t "ただ、一つだけ…";
  t "薄れてくれない記憶がある。";
  t "それが一体いつの事なのか";
  t "どこで起きた事なのか";
  t "それどころかそれが現実の事であったのかすら定かでない";
  t "そのくせ妙にハッキリと脳裏に刻まれたその記憶。";
  t "なんとなく、暗闇の中、だったような気がする";
  t "いつだって";
  t "今でも";
  t "目を閉じればすぐに浮かぶ";
  t "そう、確かなのは―――";
  t "―――右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右右左左右左右右左左右右"
|]

let normal_end = [|
  t "ああ、失敗した！怖いのが来る！もうやめて！頭をぐちゃぐちゃにしないで！";
  t "ノイズが滅茶苦茶なバランスをとらなくちゃバランスをバランスをあああああああ―――";
  i "myson_blur";
  t "「おとうさん、どうしたの？」";
  t "ふと、かけられた声で意識が覚醒した。";
  t "「あ、ああ、バランスを―――いや、なんでもないよ」";
  t "そうだ、これ以上考えるのはよそう。";
  t "きっとこの記憶に意味はない。";
  t "「そうだ、明日は久しぶりに、科学館にでも連れて行ってやろうか？」";
  t "「ほんと！やったー！」";
  t "「なんだっけか、丁度確か新しい特別展をやってるはずだな、確か―――」";
|]

let true_end = [|
  t "ああ、失敗した！怖いのが来る！もうやめて！頭をぐちゃぐちゃにしないで！";
  t "ノイズが滅茶苦茶なバランスをとらなくちゃバランスをバランスをあああああああ―――";
  i "myson_blur";
  t "「おとうさん、どうしたの？」";
  t "ふと、かけられた声で意識が覚醒した。";
  t "「おとうさん、どうしたの？」";
  t "「おおとうさん、どうしたの？」";
  t "「おおおおとうさん、どうしたの？」";
  i "myson";
  t "「お？」";
  t "『あーあ、ダメだこりゃ、どうも、シミュレータにバグがあったみたいだ』";
  t "『あら、すぐに直せる感じのやつかい？』";
  t "『見てみないと分からん。まあ、とりあえず直るまで彼には冷蔵庫でしばらくお休みしててもらわなきゃ』";
  t "『そうね、それじゃあ』";
  t "『おやすみ』"
|]

let fetch chapter =
  let idx = ref 0 in
  fun () ->
    if !idx >= Array.length chapter then Nop
    else
      let cmd = chapter.(!idx) in
      idx := !idx + 1;
      cmd
