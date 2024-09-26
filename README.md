# wandb-artifact-vllm

# vLLM-WandB デモ

![Docker イメージサイズ](https://img.shields.io/docker/image-size/nejumi/vllm-wandb-demo/v0)
![Docker Pulls](https://img.shields.io/docker/pulls/nejumi/vllm-wandb-demo)
![ライセンス](https://img.shields.io/badge/license-MIT-blue.svg)

## 概要

**vLLM-WandB デモ**は、[Weights & Biases (WandB)](https://www.wandb.com/)と[vLLM](https://github.com/vllm-project/vllm)を統合し、さくらインターネットのDockerコンテナ上で効率的に言語モデルをデプロイするためのプロジェクトです。これにより、学習・チューニングしたモデルのデプロイとAPI化が容易になります。

## 特徴

- **簡単なデプロイ**: Dockerを利用して迅速に環境を構築。
- **WandB統合**: WandBアーティファクトからモデルを自動的にダウンロード。
- **API互換性**: OpenAIのAPIと互換性があり、既存のツールやアプリケーションと簡単に統合可能。
- **GPUサポート**: 高速なモデル推論のためにGPUを活用。

## 前提条件

- **Docker**: インストール済み ([インストールガイド](https://docs.docker.com/get-docker/))
- **Docker Hubアカウント**: イメージのプルに必要。
- **WandBアカウント**: モデルアーティファクトへのアクセスに必要。
- **GPUおよびCUDAサポート**: モデル推論のために推奨。

## 使用方法

### Docker イメージのプル

Docker Hubから既にプッシュされたイメージをプルします。

```bash
docker pull nejumi/vllm-wandb-demo:v0
```

### Docker コンテナの実行

以下のコマンドでコンテナを実行します。環境変数を適切に設定してください。

```bash
docker run --gpus all \
    -p 8000:8000 \
    --env WANDB_ENTITY=your_entity \
    --env WANDB_PROJECT=your_project \
    --env WANDB_API_KEY=your_api_key \
    --env WANDB_ARTIFACT_PATH=your_artifact_path \
    --env VLLM_ARGS="--quantization gptq --dtype float16 --max-model-len 4096" \
    --ipc=host \
    nejumi/vllm-wandb-demo:v0
```

**例:**

```bash
docker run --gpus all \
    -p 8000:8000 \
    --env WANDB_ENTITY=wandb-sakura-internet \
    --env WANDB_PROJECT=vllm-wandb-demo \
    --env WANDB_API_KEY=あなたのWandB_API_KEY \
    --env WANDB_ARTIFACT_PATH=wandb32/wandb-registry-Sakura-Integration-test/Test_Model:v0 \
    --env VLLM_ARGS="--dtype float16 --max-model-len 4096" \
    --ipc=host \
    nejumi/vllm-wandb-demo:v0
```

### APIへのアクセス

コンテナが起動したら、`http://localhost:8000` でAPIにアクセスできます。以下はcURLを使用した例です。

#### cURL例

**シンプルな補完リクエスト**

```bash
curl -X POST "http://localhost:8000/v1/completions" \
     -H "Content-Type: application/json" \
     -d '{
           "model": "/models",
           "prompt": "こんにちは、今日はどんな天気ですか？",
           "max_tokens": 100,
           "temperature": 0.7
         }'
```

#### Pythonクライアント例

```python
import requests
import json

# APIエンドポイント
url = "http://localhost:8000/v1/completions"

# リクエストヘッダー
headers = {
    "Content-Type": "application/json",
}

# リクエストボディ
data = {
    "model": "/models",
    "prompt": "こんにちは、今日はどんな天気ですか？",
    "max_tokens": 100,
    "temperature": 0.7
}

# POSTリクエスト送信
response = requests.post(url, headers=headers, data=json.dumps(data))

# レスポンスの確認
if response.status_code == 200:
    result = response.json()
    print("生成されたテキスト:", result.get("choices")[0].get("text"))
else:
    print("エラー:", response.status_code)
    print(response.text)
```

**出力例:**

```
生成されたテキスト: 今日は晴れです。気温も快適で、散歩日和ですね。
```

## お問い合わせ

**Yuya Yamamoto**

- Email: [dr_jingles@mac.com](dr_jingles@mac.com)
- GitHub: [nejumi](https://github.com/nejumi)

---

*このREADMEはプロジェクトの概要と基本的な使用方法を簡潔にまとめたものです。必要に応じて内容を追加・修正してください。*
