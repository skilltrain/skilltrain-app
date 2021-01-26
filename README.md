
<div align="center">
<img src="./assets/icon/icon.png" width="100">
</div>
<div style="text-align: center;">skillTrain</div>

スキルトレインとは、トレーニングインストラクターと生徒とをマッチングさせ、オンラインレッスンを行うためのandroidスマートフォンアプリです。

```
1. 必要条件
2. システム概要
3. インストール方法
4. 使い方
5. 各機能について
  5-1. Sign in/Log in
  5-2. トレイナーページ / トレイニーページ
  5-3. ビデオチャット
  5-4. テキストチャット
  5-5. 支払い  
6. ライセンス情報
```
## 1. 必要条件
```
flutter
  amazon_cognito_identity_dart_2: ^0.1.24
  amplify_storage_s3: "<1.0.0"
  amplify_core: "<1.0.0"
  amplify_auth_cognito: "<1.0.0"
  amplify_analytics_pinpoint: "<1.0.0"
  intl: ^0.16.1
  date_calc: ^0.1.0
  file_picker: "^1.8.0+1"
  stripe_payment: ^1.0.6
  http: ^0.12.1
  agora_rtc_engine: ^3.1.3
  permission_handler: ^5.0.1
  flutter_dotenv: ^2.0.1
  modal_progress_hud: ^0.1.3
  shared_preferences: ^0.5.12+4
  url_launcher: ^3.0.3
  material_design_icons_flutter: 4.0.5855
  spannable_grid: ^0.1.0
  flutter_launcher_icons: "^0.8.0"
  flutter_rating_bar: ^3.2.0+1
  web_socket_channel: ^1.2.0
  share: ^0.5.3
  transparent_image: ^1.0.0
```
## 2. システム概要

## 3.インストール方法

Androidストアより以下のアプリケーションをダウンロードし、インスールしてください。
https://play.google.com/store/apps/details?id=com.skillTrain.skillTrain

## 4.使い方

## 5.各機能について

  ### 5-1. Sign up/Log in
  サインアップ時にトレイナーとして登録するかトレイニーとして登録するかを選択します。
  登録に必要な情報を登録後、トレイナーはトレイナー専用ページに、トレイニーはトレイニー専用ページに遷移します。  

  ユーザー認証はAWSの認証システムにより行われます。flutter上での実装にあたっては以下のライブラリを使用しています。  
  amazon_cognito_identity_dart_2: ^0.1.24  
  amplify_core: "<1.0.0"  
  amplify_auth_cognito: "<1.0.0"  

  ### 5-2. トレイナーページ / トレイニーページ
  トレイナーとトレイニーの各ページの機能は以下の通り  
    
  ＜トレイナー＞
  支払い情報登録  
  講義登録  
  講義情報変更  
  講師情報更新  
  
  注意  
  支払い情報登録を完了していない場合、講師は新たに講義登録を行うことができません。  
  
  ＜トレイニー＞  
  
  ### 5-3. ビデオチャット
  トレイナーとトレイニーはビデオチャットを介してオンラインレッスンを行うことができます。  
  
  ビデオチャットには以下のflutterライブラリが使用されています。
  ```
  agora_rtc_engine: ^3.1.3
  ```
  ### 5-4. テキストチャット
  トレイナーとトレイニーはテキストチャットを介してレッスン開始前に連絡を行うことができます。  

  テキストチャットには以下のflutterライブラリが使用されています。  
  ```
  agora_rtc_engine: ^3.1.3
  permission_handler: ^5.0.1
  ```
  ### 5-5. 支払い  
  レッスン予約後にStripeを介してレッスン代を支払うことができます。
  支払い完了後にレッスン予約の情報が反映されます。
  
  支払いには以下のflutterライブラリが使用されています。  
  ```
  stripe_payment: ^1.0.6
  ```

## 6.ライセンス

androidスマートフォン
