# Humidity Monitoring Simulation System

[![license](https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat)](https://github.com/STonami/mypkg?tab=BSD-3-Clause-1-ov-file)

## 概要
このパッケージは、ROS2 を用いて湿度データの監視と異常値の検出をシミュレーションするシステムです。

- **メイン機能**: 湿度データの生成および異常値検出
- **補助機能**: テスト用ノード

## ノードの説明

### 1. **メインノード: `humidity_publisher`**

- **役割**:
  - 湿度データをシミュレートし、トピック `/humidity_data` にパブリッシュします。
  - 異常値が検出された場合、アラートを `/humidity_alerts` に送信します。

- **実装のポイント**:
  - 正常範囲: 30% ～ 70%
  - タイマーで 1 秒ごとにデータを生成。
  - **10% の確率で異常値を生成**。

- **実行方法**:
```bash
ros2 run mypkg humidity_publisher
```

- **トピック**:
  - `/humidity_data` (湿度データ)
  - `/humidity_alerts` (異常アラート)

- **出力例**:
```
[INFO] [1736004774.940271865] [humidity_publisher]: Published Humidity: 45.32%
[WARN] [1736004775.940271865] [humidity_publisher]: Abnormal Humidity Detected: 15.21%!
```

### 2. **補助ノード: `humidity_subscriber`**

- **役割**: 
  - `/humidity_data` トピックを読み、データを受信。
  - テスト目的での使用を想定。

- **実行方法**:
```bash
ros2 run mypkg humidity_subscriber
```

- **出力例**:
```
[INFO] [1736051197.424672914] [humidity_subscriber]: Received: Humidity is 45.32%
```

## 実行手順

**ノードを実行する**
```bash
ros2 run mypkg humidity_publisher
```

## 出力確認

### `/humidity_data` トピックの確認
```bash
ros2 topic echo /humidity_data
```

### `/humidity_alerts` トピックの確認
```bash
ros2 topic echo /humidity_alerts
```

## 実行環境

### 必要なソフトウェア
- Python
  - テスト済みバージョン: 3.7 ～ 3.10
- ROS2
  - テスト済みバージョン: Foxy, Humble

### テスト環境
- Ubuntu 24.04 LTS

## ライセンス
このソフトウェアパッケージは、3条項BSDライセンスの下, 再頒布および使用が許可されます。

- © 2025 Tonami Seki

