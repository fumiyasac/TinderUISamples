# TinderUISamples
[ING] - TinderのようなUIを様々な実装で実現してみるサンプル

今回はTinder風のUIを自前で用意する際の実装ポイントや気をつけるべき点等を知りたいと感じたので、同様な形ではあるが内部実装は全く異なるTinder風UIサンプルを2種類を用意しました。

### 本サンプルの画面キャプチャ

![sample_summary.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/eaaa7c4e-726d-fa7c-5f80-af4167fc6113.jpeg)

### 実装例1. UIView + UIPanGestureRecognizerを利用したUI実装

動かすカードのView側にProtocolをあらかじめ定義しておき、UIViewControllerを連携してGestureRecognizer発動時のタイミングで行われる処理（左右への動きやスワイプ後などの処理）を実行するような形の実装になっています。

__画面デザインのラフスケッチ:__

![example1_design.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/fbc8eb01-0589-f4d1-0d19-0da6ff85e103.jpeg)

__クラスの関係図＆解説メモ:__

![example1_memo.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/f51d736f-ce3e-8a66-4745-4053d86fef72.jpeg)

### 実装例2. UICollectionView + UILongPressGestureRecognizerを利用したUI実装

UICollectionViewLayoutクラスを継承したクラスを利用してカード表示画面の設定を行い、GestureRecognizer発動時のタイミングで行われる処理と組み合わせる形の実装になっています。

UILongPressGestureRecognizer経由で対象のセルを選び出した後は、stateプロパティの状態を元にそれぞれの処理を記載していく形になります。
このサンプルで実際に動いているのは、選び出したUICollectionViewCellではなく、 __「UICollectionViewCellのスナップショットを表示したUIImageView」__ になります。

__画面デザインのラフスケッチ:__

![example2_design.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/b2a11743-5600-a9fb-fad0-dc6fd2e7dd47.jpeg)

__クラスの関係図＆解説メモ:__

![example2_memo.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/609974e2-39e4-1c35-15b5-99f7fd07251b.jpeg)

### その他

このサンプル全体の詳細解説とポイントをまとめたものは下記に掲載しております。

+ (Qiita) https://qiita.com/fumiyasac@github/items/c68b7ce812bf3ef48a67
