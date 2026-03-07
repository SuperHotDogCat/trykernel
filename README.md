# trykernel
## Detail
- file単位でhardware依存部分とそうでない部分を分ける

## Set up
- [Embedded system gcc](https://xpack.github.io/web-archive-jekyll/dev-tools/arm-none-eabi-gcc/#change-log)をdownloadしたcontainerを作る
```
docker build -t embed .
docker run -it -v $(pwd):/workspace --rm embed
arm-none-eabi-gcc --version # 動くかを確認
```

## Explain
- 全体
- Initの仕方, vector tableをどこに置くかも決める
```
source.c
   ↓
gcc compile
   ↓
object file (.o)
   ↓
linker (ld)
   ↑
linker script
   ↓
executable
```
- リンカスクリプト
- EntryにReset_Handlerを置き, ROMとRAMの置き場所を指定する
- Entryが最初に実行されるもの
```
ENTRY(Reset_Handler)

MEMORY {
    ROM (rx)	: ORIGIN = 0x10000000, LENGTH = 2048K
    RAM (xrw)	: ORIGIN = 0x20000000, LENGTH = 256K
}
```

## 用語とか
- ペリフェラル: 入出力や制御を担当する周辺機器

| ペリフェラル | 役割          |
| ------ | ----------- |
| GPIO   | ピンのON/OFF   |
| UART   | シリアル通信      |
| SPI    | 高速通信        |
| I2C    | センサ通信       |
| Timer  | 時間計測        |
| ADC    | アナログ→デジタル変換 |
| PWM    | モーター制御      |
- ペリフェラルのレジスタは32ビットのサイズでメモリ空間にmapされてるのでpointerへの書き込みなどでアクセスを行う
- [RP2040のdata sheet](https://akizukidenshi.com/goodsaffix/rp2040-datasheet.pdf)の2.3.1.7にペリフェラルのレジスタ関連の情報はある
