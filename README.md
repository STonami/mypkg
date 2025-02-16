# mypkg

[![test.bash](https://github.com/STonami/mypkg/actions/workflows/test.yml/badge.svg)](https://github.com/STonami/mypkg/actions/workflows/test.yml)
[![license](https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat)](https://github.com/STonami/mypkg?tab=BSD-3-Clause-1-ov-file)

## 概要
このパッケージは、ROS2 を用いてバッテリー状態を監視するシステムです。

### `battery_status_publisher`

- **機能**:
  - バッテリーのパーセントを監視し、トピック `/battery/percents` にパブリッシュします。
  - バッテリーの充電状態（充電中・放電中）を通知します。
  - バッテリー情報が取得できない場合はエラーメッセージを送信

## 実行方法

### ノードの実行
```bash
ros2 run mypkg battery_status_publisher
```

### 出力確認

#### `/battery/percents` トピックの確認
```bash
ros2 topic echo /battery/percents
```

#### 出力例
```
Battery: 85.3%, Status: Discharging, Time: 2025-02-16 12:34:56
Battery: 85.1%, Status: Discharging, Time: 2025-02-16 12:34:57
```

## 実行環境

### 必要なソフトウェア
- Python (3.7 ～ 3.10 で動作確認済み)
- ROS2 (Foxy, Humble で動作確認済み)

## ライセンス
このソフトウェアパッケージは、3 条項 BSD ライセンスの下、再頒布および使用が許可されます。

- © 2025 Tonami Seki


