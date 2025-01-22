テスト環境の記述を削除したREADME.mdを以下に修正しました。

---

# Battery Monitoring System

[![license](https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat)](https://github.com/STonami/mypkg?tab=BSD-3-Clause-1-ov-file)

## 概要
このパッケージは、ROS2 を用いてバッテリー状態を監視するするシステムです。

- **メイン機能**: バッテリーのパーセント監視および状態（充電中・放電中）の通知
- **補助機能**: バッテリー情報を定期的に送信するノード

## ノードの説明

###  ** `battery_status_publisher`**

- **役割**:
  - バッテリーのパーセントを監視し、トピック `/battery/percents` にパブリッシュします。
  - バッテリーの充電状態（充電中・放電中）も併せて通知します。

- **実装のポイント**:
  - バッテリーのパーセント（0～100%）を 1 秒ごとに取得。
  - **バッテリー情報が取得できない場合はエラーメッセージを送信**。

- **実行方法**:
```bash
ros2 run mypkg battery_status_publisher
```

- **トピック**:
  - `/battery/percents` (バッテリーのパーセント情報)
  
## 実行手順

**ノードを実行する**
```bash
ros2 run mypkg battery_status_publisher
```

## 出力確認

### `/battery/percents` トピックの確認
```bash
ros2 topic echo /battery/percents
```

## 実行環境

### 必要なソフトウェア
- Python
  - テスト済みバージョン: 3.7 ～ 3.10
- ROS2
  - テスト済みバージョン: Foxy, Humble

## ライセンス
このソフトウェアパッケージは、3条項BSDライセンスの下, 再頒布および使用が許可されます。

- © 2025 Tonami Seki

---
