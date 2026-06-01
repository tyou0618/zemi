#set text(font:"IPAexMincho",12pt,weight:"black")
#set par(
  justify: true,
  first-line-indent: (all: true, amount: 0em)
)
#set heading(numbering: "1.1.a.")
#set page(numbering: "1")
#show link: set text(fill: blue)

#align(center)[
  #text(24pt, "卒業研究 現在の進行状況")
]
#align(right)[
  #text(12pt, "2026年   月   日  髙宮 悠聖")
]

= YOLOについて

// ==========================================
// 1. コードブロックのデザイン設定（見やすく装飾）
// ==========================================
#show raw.where(block: true): it => block(
  fill: luma(240),          // 薄いグレーの背景
  inset: 12pt,              // 内側の余白
  radius: 6pt,              // 角を丸くする
  width: 100%,              // 横幅いっぱい
  stroke: 0.5pt + luma(200) // 薄い枠線
)[
  #set text(size: 7pt, font: "DejaVu Sans Mono") // コードのフォントサイズと種類
  #it
]

// ==========================================
// 2. ソースコードの掲載（キャプション付き）
// ==========================================

#figure(
  raw("
import sys
import csv
import time
import os
from collections import defaultdict
from ultralytics import YOLO

# --- 引数 ---
version = sys.argv[1] if len(sys.argv) > 1 else '11'
size = sys.argv[2] if len(sys.argv) > 2 else 'n'
input_path = sys.argv[3] if len(sys.argv) > 3 else 'images'

# --- モデル読み込み ---
if version == '8':
    model_name = f'yolov8{size}.pt'
elif version == '11':
    model_name = f'yolo11{size}.pt'
else:
    raise ValueError('versionは 8 か 11')

model = YOLO(model_name)

# --- 画像取得 ---
image_files = []
if os.path.isdir(input_path):
    for file in os.listdir(input_path):
        if file.lower().endswith(('.jpg', '.png', '.jpeg')):
            image_files.append(os.path.join(input_path, file))
else:
    image_files.append(input_path)

# --- 推論とCSV記録 ---
csv_file = 'results/compare.csv'
os.makedirs('results', exist_ok=True)

with open(csv_file, 'a', newline='') as f:
    writer = csv.writer(f)
    if f.tell() == 0:
        writer.writerow(['model', 'image', 'detections', 'avg_conf', 'time'])

    for img in image_files:
        try:
            start = time.time()
            results = model(img, save=True, project=f'results/v{version}', name=size)
            end = time.time()

            result = results[0]
            num_detections = len(result.boxes)
            avg_conf = float(result.boxes.conf.mean()) if num_detections > 0 else 0.0

            writer.writerow([
                model_name, img, num_detections, round(avg_conf, 4), round(end - start, 4)
            ])
        except Exception as e:
            print(f'Error: {e}')
", lang: "python", block: true),
) <yolo-script>
