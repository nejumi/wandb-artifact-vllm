# ベースイメージとして公式の vLLM イメージを使用
FROM vllm/vllm-openai:latest

# 作業ディレクトリを設定
WORKDIR /app

# 必要な Python パッケージをインストール
RUN pip install --no-cache-dir wandb

# スタートアップスクリプトをコピー
COPY start.sh /app/start.sh

# スクリプトに実行権限を付与
RUN chmod +x /app/start.sh

# ENTRYPOINT をスタートアップスクリプトに設定
ENTRYPOINT ["/app/start.sh"]
