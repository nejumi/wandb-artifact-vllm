#!/bin/bash
set -e

# 環境変数のチェック
if [ -z "$WANDB_API_KEY" ]; then
  echo "Error: WANDB_API_KEY is not set."
  exit 1
fi

if [ -z "$WANDB_ARTIFACT_PATH" ]; then
  echo "Error: WANDB_ARTIFACT_PATH is not set."
  exit 1
fi

# wandb にログイン
export WANDB_API_KEY=$WANDB_API_KEY

# モデルを保存するディレクトリを設定
MODEL_DIR=$WANDB_ARTIFACT_PATH
mkdir -p $MODEL_DIR

# wandb からモデルをダウンロード
echo "Downloading model from wandb..."
python3 - <<EOF
import wandb
import os

wandb_entity = os.environ.get('WANDB_ENTITY')
wandb_project = os.environ.get('WANDB_PROJECT')

run = wandb.init(entity=wandb_entity, project=wandb_project)
artifact_path = os.environ.get('WANDB_ARTIFACT_PATH')
artifact = wandb.use_artifact(artifact_path, type='model')
artifact_dir = artifact.download(root='$MODEL_DIR')
print(f"Model downloaded to {artifact_dir}")
run.finish()
EOF

# vLLM の追加引数を環境変数から取得
VLLM_ARGS=${VLLM_ARGS:-""}

# vLLM API サーバーを起動
echo "Starting vLLM OpenAI API server..."
exec python3 -m vllm.entrypoints.openai.api_server --model $MODEL_DIR --host 0.0.0.0 --port 8000 $VLLM_ARGS
