## TA_Time_Management_System
本アプリケーションはティーチングアシスタント(TA)のシフトの管理およびシフト表の出力を行うアプリケーションである．
## Installation
- git を用いてディレクトリのダウンロード
  ```
  $ git clone https://github.com/KentaYoshioka/TA_Time_Management_System.git

  ```
- 依存関係のインストール，データベースのマイグレーション
  ```
  $ make setup
  ```

- 初期データ(授業情報等)のインストール
  ```
  $ make import
  ```
- システムの起動
  ```
  $ make start
  ```

## Install for Docker 
- コンテナの構築
  ```
  make docker-up
  ```
- 依存関係のインストール，データベースのマイグレーション
  ```
  make docker-setup
  ```
- システムの起動
  ```
  $ make docker-start
  ```
  
