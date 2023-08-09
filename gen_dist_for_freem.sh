#!/bin/bash

set -eu

rm -rf dist
mkdir -p dist
cp -r img dist
cp -r css dist
cp -r js dist
cp index.html dist
cp favicon.ico dist
echo "ゲーム名 「NORGANOID」
製作 WAFT

ストーリー:
家族に囲まれ、幸せな日々を過ごす主人公。
しかし、彼には一つだけ不可解な記憶がありました。
それは、無機質な白黒の画面でひたすらボールを打ち返すゲームをプレイしている記憶。
実際にあったことなのかすら定かではないその記憶は、
しかし確かにしばしば彼の精神をさいなまんでいた。
そう、目を閉じれば、いつだってその記憶がよみがえり―――

操作方法:
PCをお使いのかたはマウスでモバイル端末をお使いのかたはタッチのみでプレイできます。

タッチ/クリック: テキストを次に進める
マウス移動/スワイプ: 反射板を移動

ゲームのルール:
プレイヤーは画面下部にある反射板を動かすことができます。
可能な限り長く、白いボールを下に落とさないように頑張ってください。
ボールは画面端と反射板で反射し、反射板にあてるたびに得点が加算されます。

攻略のヒント:
得点が50を超えると、ボールが不可視になります。
ボールと反射板の位置関係によって周波数の変わるブザー音を良く聞き分けて
ボールの位置を推測してください。

BGM:
【DOVA-SYNDROME】
不穏 written by こっけ
砂嵐の音・テレビのホワイトノイズ音 written by Causality Sound

***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************
******************** 以下はネタバレとなるのでご注意ください ******************
***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************

エンディング条件
* 得点が100未満でボールを落とす: ゲームオーバー
* 得点が200未満でボールを落とす: ノーマルエンド
* 得点が200以上でボールを落とす: 真エンド

ストーリー(真相)
　主人公の正体は人間ではなく、ヒト脳オルガノイド。
オルガノイドとは、幹細胞を三次元培養して得られる組織のことで、
特にヒト脳オルガノイドはヒト脳の構造や生理機能を詳細に再現することで
医療応用や実験を目的に作成される。

　主人公はヒト脳オルガノイドに心や感情が発生するのかという実験の為、
シミュレータによって仮想的に実現された「家族に囲まれた平穏な生活」
を電気信号として流され続けていた。真エンドでは、このシミュレータが
故障してしまい、しばらく実験は凍結されることになる。

　主人公が時々思い出していた不可解な記憶は、
今回の実験の前に行われていた実験が原因で、そこでは、
ヒト脳オルガノイドの学習能力を検証するために簡易的なゲームをプレイさせられていた。

ゲームオーバー時に流れるノイズは、この実験で失敗時に流されたランダムな信号。

実験の元ネタ:
人工培養脳にテニスゲームを教えると5分で理解し遊び始めると判明！
https://nazology.net/archives/102025

" > ./dist/ReadMe.txt

pushd ./dist
zip -r for_freem.zip css img js favicon.ico index.html ReadMe.txt
popd