# 移動ド音程チェッカー（PitchChecker-Web）

マイク入力の音高を **移動ド（可動ド）** で表示するブラウザアプリ。単一 HTML・依存ライブラリなし。

## 起動
- `起動.command` をダブルクリック → ローカルサーバ(:8765)を起動し Chrome で開く
- `停止.command` でサーバ停止
- ※ `file://` 直開きではマイクが使えない（Secure Context 必須）。必ず `http://localhost:8765/` で開く。

## ファイル
| ファイル | 役割 |
|---|---|
| `index.html` | アプリ本体（UI・音楽理論・ピッチ検出すべて） |
| `起動.command` / `停止.command` | ローカルサーバ操作 |

## 実装の要点
- **ピッチ検出**: NSDF（McLeod Pitch Method）+ 放物線補間。`detectPitch()`
  - 窓 2048 サンプル（≒43ms）、検出域 55〜1600Hz、clarity 0.5 未満は棄却
  - 検出周期 25ms、直近 3 回の中央値で平滑化
- **移動ドマッピング**: `buildKey(rootPc, mode, minorSystem, minorScale, lang)`
  - 12 音すべてに `{name(階名), deg(度数), inScale}` を割り当てた表を返す
  - 階名の綴りは「度数から素の階名 → 実距離との差を♯♭に」で決めるので、
    ハーモニックマイナーの導音が **ラ♭ ではなく ソ♯** と正しく出る
  - ラ基準マイナーでは非スケール音の 8 半音も ソ♯ に上書き（`chrom[8]`）
- 設定は localStorage(`movabledo.settings.v1`) に保存
- テスト用フック: `window.__mdc = {buildKey, detectPitch, pcName, S, KEY}`

## 検証済み（2026-07-31）
- 合成波での精度: 82.4Hz〜1174.7Hz で誤差 **±0.3 cent 以内**、clarity ≒1.00
- 無音 → 検出なし / 処理時間 20 回で 112ms（波形生成込み・1 回あたり余裕あり）
- MediaStreamDestination を getUserMedia に差し込み、UI 全体を実走行で確認
  - Key=Am/ラ基準/ハーモニック: G♯4→「ソ♯ / 7度（導音・Ⅴ7）」、G4→「ソ / ♭7度（スケール外）」
  - ±20c / -35c / +40c でメーター位置・判定文言が一致
  - キー・体系・スケール・言語の切替、localStorage 復元

## 既知の制限 / 次の候補
- タブが非アクティブだと requestAnimationFrame が止まる（＝検出も止まる）。仕様として許容。
- 単音のみ。和音・重音は不可。
- **iPhone で使うには https が必要**（LAN の生 IP では Safari がマイクを許可しない）。
  → GitHub Pages 公開が最短。未実施（ユーザー承認待ち）。
- 候補: 基準音の再生（聴き比べ）、録音して階名の履歴を残す、移調楽器対応、Ⅴ7 以外のセカンダリドミナント表示
