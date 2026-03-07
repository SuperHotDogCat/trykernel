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
- elf2uf2
```
git clone https://github.com/rej696/elf2uf2.git
make
```
- rp2024js(for emulator)
```
git clone git@github.com:wokwi/rp2040js.git
cd rp2040js
npm install
# npm run start -- --image ../kernel.uf2で使う
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

- sections
  - bss (Block Storage Section): 初期値のないグローバル変数, デフォルトを0で初期化する
  - data: 初期値のあるグローバル変数
  - rodata (Read Only Data): グローバル変数の初期値
