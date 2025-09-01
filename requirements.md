# ドキマチ（lovemaggedon） アプリ要件定義・詳細仕様

## 概要
- **アプリ名**: ドキマチ（ドキドキマッチング）
- **種別**: パーティー向けリアルタイム・マッチング表示アプリ（Flutter）
- **対象プラットフォーム**: iOS / Android / Web / デスクトップ（Flutter標準出力に準拠）
- **UIフレームワーク**: Flutter Material
- **状態管理**: flutter_riverpod
- **主なパッケージ**:
  - camera / camera_avfoundation（カメラ撮影）
  - permission_handler（カメラ権限）
  - path_provider（将来の保存用途を想定、現状未直接使用）
  - cupertino_icons（UI）
- **アプリ起動名/タイトル**: タイトル文字列は`MyApp`の`MaterialApp.title`に「ドキマチ」、ホーム画面`HomePage`見出しは「ドキドキマッチング！！」

## 用語定義
- **参加者（Member）**: ゲームに参加する一人。性別・名前・顔写真画像パス・内部インデックスを持つ。
- **参加者数（memberNum）**: 男女合計の総参加人数。`SettingPage`で確定し、以後変更不可。
- **登録順インデックス（memberIndex）**: 現在登録処理・選択処理の対象となる参加者のインデックス。0起算。
- **想い（Love）**: ある参加者`fromIndex`が、気になる相手`toIndex`を指す有向関係。
- **結び線（Line）**: 演出用の描画情報。気持ちの矢印を表す点線をアニメーション描画するための座標情報。

## ドメインモデル
### Member（lib/models/member.dart）
- フィールド:
  - `int index`（必須）: 0起算の一意な参加者インデックス。登録順に割り当て。
  - `String sex`（必須）: 性別。UI上「男の子」または「女の子」を選択。比較は完全一致文字列。
  - `String name`（必須）: 表示名。
  - `String image`（必須）: 端末内の画像ファイルパス。
  - `late int loveMemberIndex`: 選んだ相手の`index`。`setLoveMember`呼出しで代入されるまで未初期化。
- メソッド:
  - `setLoveMember(int index)`: `loveMemberIndex`に相手の`index`を設定。
- 制約:
  - `index`は0..(memberNum-1)の範囲で一意であること。
  - `sex`は「男の子」/「女の子」。他値は想定外（UIでは選べない）。
  - `image`は端末ファイルパス。存在前提でFile読み込み（存在チェックなし）。

### Love（lib/models/love.dart）
- フィールド: `int fromIndex`, `int toIndex`（いずれも0起算）。
- 役割: 参加者間の「気になる」関係（有向）。

### Line（lib/models/line.dart）
- フィールド: `double startX`, `startY`, `endX`, `endY`。
- 役割: `CustomPainter`に渡される線分の描画座標。

## グローバル状態（lib/providers.dart）
- `memberNumProvider: StateProvider<int>` 初期値0。設定画面で確定。
- `memberIndexProvider: StateProvider<int>` 初期値0。登録/選択フローの現在インデックス。
- `cameraProvider: FutureProvider<CameraDescription>` 利用可能カメラ一覧から`cameras[1]`（一般にフロント）を返却。
  - 仕様上、端末が1台以上のカメラを持ち、2台目（インデックス1）が存在する前提。
- `membersProvider: StateProvider<List<Member>>` 初期値空リスト。登録時に`Member`を末尾追加。

## 画面フロー
### アプリ起動（lib/main.dart, HomePage）
- `ProviderScope`配下で起動。
- ホーム画面`HomePage`表示。
  - メインビジュアルとテキスト（「今夜誰かが結ばれる？！」「ドキドキマッチング」）を表示。
  - 「スタート」ボタン押下で`SettingPage`へ遷移。

### 設定（SettingPage）
- 入力: 男女合計の参加人数（プルダウン）。選択肢: 2..12（整数）。初期2。
- 確定ボタン押下時:
  - 確認ダイアログ表示。
  - OKで`memberNumProvider`に確定値を設定。
  - `GuidePage`に遷移。
- 注意: 確定後は人数変更不可（ダイアログ文言で告知）。

### ガイド（GuidePage）
- `memberIndex`と`memberNum`を監視。
- 分岐:
  - `memberIndex >= memberNum` → 全員登録完了。文言表示→「次に進む」で`AllMembersPage`へ。
  - それ以外 → `cameraProvider`準備。
    - 読み込み中: ローディング表示。
    - 取得エラー: エラー表示。
    - 取得成功: 「N番目の参加者を登録するよ！」と表示→「次に進む」で`CameraPage`へ。

### カメラ撮影（CameraPage）
- 初期化:
  - `CameraController`を`ResolutionPreset.medium`, `ImageFormatGroup.bgra8888`, `enableAudio=false`で初期化。
  - `_checkCameraPermission()`を同時実行。camera権限が`granted`以外ならリクエスト。
  - 権限が付与されない場合`_cameraPermissionDenied=true`、許可待ち文言と「ホームに戻る」表示。
- 表示:
  - 権限OKかつ初期化完了で`CameraPreview`と「自撮りをしてね」テキスト。
  - 中央下`FloatingActionButton`押下で撮影。
- 撮影後:
  - `RegisterPage(imagePath)`へプッシュ遷移。
- リセット操作（ホームへ戻る）:
  - `memberNum=0`, `memberIndex=0`, `members=[]`に初期化してHomeへ。

### 参加者登録（RegisterPage）
- 入力要素:
  - 撮影画像プレビュー（引数`imagePath`）。
  - 名前: テキスト入力（必須）。
  - 性別: プルダウン（「男の子」/「女の子」）（必須）。
- 操作:
  - 「撮り直す」: 確認ダイアログOKで前画面に戻る（カメラへ）。
  - 「登録する」: 確認ダイアログOK時に入力検証。
    - 未入力（名前 or 性別）→ SnackBarでエラー表示、登録しない。
    - 入力OK→ `Member(index, sex, name, imagePath)`作成し、`members`末尾に追加。
      - ここで`index`は現在の`memberIndex`値。
      - `memberIndex`を`+1`。
      - `GuidePage`へ遷移（次の参加者登録フロー）。

### 登録者一覧（AllMembersPage）
- 初回描画後に`memberIndex`を0にリセット。
- `members`を性別で2リストに分割:
  - 男の子: `sex == '男の子'`
  - 女の子: `sex == '女の子'`
- 片方の性別しかいない（どちらかが空）→ ゲーム不可メッセージ＋リセットボタン（Homeへ、全状態リセット）。
- 両性がいる→ 男の子リスト、女の子リストを横スクロールで表示（`MemberComponent`）。
- 「気になる相手を選ぶ」押下で`MatchGuidePage`へ遷移。

### 選択ガイド（MatchGuidePage）
- `memberIndex`と`members`を監視。
- 分岐:
  - `memberIndex >= memberNum` → 全員の選択完了。最終演出へ進むボタンで`CouplingPage`へ。
  - それ以外 → 現在の選択者`chooser = members[memberIndex]`を表示し、「気になる相手を選んでね♡」。
    - 「次に進む」で`ChoosePage`へ。

### 相手選択（ChoosePage）
- `chooser`の性別に応じて、異性群（`chooser.sex == '男の子' ? females : males`）を候補として横スクロール表示。
- 各候補カードに「この人に決める♡」ボタン。
  - 確認ダイアログOKで:
    - `members[memberIndex].loveMemberIndex = 候補.index`を設定。
    - `memberIndex += 1`。
    - `MatchGuidePage`へ戻り、次の選択者へ。

### カップリング演出（CouplingPage）
- 入力:
  - `memberNum`、`members`（画像群・座標取得用）
  - 各参加者の`loveMemberIndex`を`Love(fromIndex, toIndex)`群へ変換し`allLoves`に格納。
- レイアウト:
  - 左列: 男の子の小カード（縦整列）
  - 右列: 女の子の小カード（縦整列）
  - 各カードに`GlobalKey`を付与し、中心座標を後段で取得。
- 操作1: 「誰かを選んでね」ドロップダウンで任意の参加者（index）を選択（初期は未選択）。
- 操作2: 「向きを選択してね」ドロップダウン
  - 選択肢: 「からの」/「への」
  - 判定:
    - 「からの」→ `fromIndex == revealIndex` の`Love`群を`matchedLoves`に抽出。
    - 「への」→ `toIndex == revealIndex` の`Love`群を抽出。
- 操作3: 「気持ちを確認する♡」
  - `revealIndex`未選択→ エラーダイアログ。
  - 選択済み→ 確認ダイアログOKで:
    - `matchedLoves`が空→ 「気になる人はいなかった」ダイアログ。閉じると直前ダイアログも閉じる。
    - 非空→ 各`Love`について、`GlobalKey`から発信者・受信者カード中心を取得し、`Line`配列を作成。アニメーションを0から再生。
    - `isOpened = true` をセット。
- 操作4: 「結ばれたか確認する」
  - `isOpened == false` → 先に気持ちを確認するよう促すダイアログ。
  - `isOpened == true` → 確認ダイアログOKで:
    - `pickedMember = allMembers[matchedLoves[0].toIndex]`を起点に、`getCouple()`で相互想いの2名を抽出。
    - 結果ダイアログ `_showPopUp()` を表示。
    - 表示後 `isOpened = false` に戻す。
- 操作5: 「最終結果を確認する」
  - 確認ダイアログOKで`FinalPage`へ。
- 描画仕様:
  - `MultiLinePainter`がピンクの点線をアニメーション描画。
  - ダッシュ長・間隔: 16px / 16px。
  - アニメーション: 2.5秒。`_controller.forward(from: 0)`で再生。

### 最終結果（FinalPage）
- `getCouples(allMembers)`で最終的に両想いの全組合せを抽出し一覧表示。
  - 抽出ロジック: 男の子群を走査し、`likedFemale = allMembers[male.loveMemberIndex]`が存在しかつ`likedFemale.loveMemberIndex == male.index`ならカップル成立（2名の並びで格納）。
- カップルが0組なら残念メッセージを表示。
- 「ホームに戻る」で全状態を初期化（`memberNum=0 / memberIndex=0 / members=[]`）し、Homeへ。

## 例外/エラー処理仕様
- カメラ権限: `Permission.camera`を起動時にチェックし、`denied`/`permanentlyDenied`ならリクエスト。未許可時は権限付与の手順文言を表示し、ゲームを進行不可。
- カメラ選択: `cameraProvider`は`cameras[1]`を返却。端末に2つ目カメラがない場合のハンドリングは未実装（取得エラー分岐で一般エラーメッセージ表示）。
- 画像ファイル存在チェック: 未実装。ファイル欠落時は`Image.file`でランタイム例外の可能性あり。
- 入力検証:
  - Register: 名前・性別が未入力なら登録不可（SnackBar表示）。
  - Choose: UI上は候補ボタンでのみ確定可能。任意の相手を必ず1名選択。
  - Coupling: 未選択や未オープン状態に対しガードダイアログを表示。

## データ整合性・前提
- `members.length == memberNum`を前提に、以降の画面（一覧・選択・演出・最終結果）を進行。
- `Member.index`は0..(memberNum-1)で一意、登録順に割り当て。
- `loveMemberIndex`は全員が必ず1名を指す想定（Chooseで強制）。
- 性別は厳密に「男の子」「女の子」のみ。文字列比較で分岐。
- 男女どちらかが0人ならゲーム不可（一覧で停止）。

## ナビゲーション仕様
- すべて`Navigator.push`による画面遷移（戻るはシステム戻る/明示ナビゲーション）。
- 状態リセットは複数画面に配置の「ホームに戻る」から実施。

## UI/デザイン仕様（共通）
- 背景画像: `assets/background.png`または`assets/background2.png`。
- 強調フォント: 見出しにフォントファミリ `'Bebas Neue'` 指定箇所有（実ファイル未定義だが既存コード依存）。
- ボタンスタイル: 主に`backgroundColor: Colors.deepPurple`、丸み10、余白指定あり。
- 画像表示: `Image.file`で表示。角丸やシャドウ付与の箇所有り。

## アセット
- `assets/icon.png`, `assets/home.png`, `assets/background.png`, `assets/background2.png` を`pubspec.yaml`で登録済み。

## 既知の制約/改善候補（リファクタリング指針）
- カメラ選択ロジックが`cameras[1]`に固定。存在チェックとフロント/バック選択の堅牢化が必要。
- `Member.loveMemberIndex`の初期化前参照リスク。null安全/未選択状態の型で表現したい（例えば`int?`や`Option`相当）。
- `membersProvider`を`StateProvider<List<Member>>`で直接ミュータブル操作（`state.add`）しており不変性が崩れる。`StateNotifier`/`Notifier`で不変更新に統一したい。
- 画像ファイル存在チェック/読み込み失敗時のプレースホルダ対応が未実装。
- 入力検証（名前の空白、文字数、重複名、絵文字等）の強化余地。
- 性別の文字列ハードコード依存。列挙型へ変更、i18nとロジックの分離が望ましい。
- 画面遷移に`push`のみ使用しスタックが増える。`pushReplacement`や`go_router`導入検討。
- マジックナンバー（サイズ、色、アニメ時間、オフセット`-102+100+2`等）が散在。定数化・テーマ化必要。
- `CameraPage`の権限ハンドリングでprintログ残存。ロギング/トーストに置換。
- `FinalPage`カップル抽出が「男の子→女の子」のみを基準。双方向or任意性別対応の一般化が必要（現状設計は男女マッチング前提）。
- 端末回転・ライフサイクル・メモリ解放（コントローラ破棄は実装済）のより厳密な管理。
- テストが最小限。ウィジェット・状態ロジック・ペインタの単体/ゴールデンテストを追加。

## 非機能要件
- 即時性: 入力操作に対してフレーム欠落なくプレビュー・アニメーションが可能。
- 耐久性: 最低参加人数2、最大12でストレスなく動作。
- プライバシー: 端末内保存の写真パスのみ使用。外部送信なし。
- ローカライズ: 画面文言は日本語固定（現状）。

## 完了判定
- 参加人数を設定し、全員の撮影と登録ができる。
- 各参加者が相手を1名選択し終えると、`CouplingPage`で個別の気持ちの可視化（点線アニメ）ができる。
- 両想いはポップアップおよび`FinalPage`で正しく一覧表示できる。
- 「ホームに戻る」で状態が初期化され、最初からやり直せる。
