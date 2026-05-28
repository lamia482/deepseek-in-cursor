FROM ngrok/ngrok:latest

USER root

# 使用国内镜像，避免 deb.debian.org 连接超时（bookworm 支持 sources.list 与 debian.sources）
RUN set -eux; \
  for f in /etc/apt/sources.list /etc/apt/sources.list.d/debian.sources; do \
    [ -f "$f" ] || continue; \
    sed -i \
      -e 's|http://deb.debian.org|http://mirrors.aliyun.com|g' \
      -e 's|https://deb.debian.org|http://mirrors.aliyun.com|g' \
      -e 's|http://security.debian.org/debian-security|http://mirrors.aliyun.com/debian-security|g' \
      -e 's|https://security.debian.org/debian-security|http://mirrors.aliyun.com/debian-security|g' \
      "$f"; \
  done

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv git ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && ln -sf python3 /usr/bin/python

RUN pip3 install --no-cache-dir --break-system-packages \
    "deepseek-cursor-proxy @ git+https://github.com/yxlao/deepseek-cursor-proxy.git"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000 4040

WORKDIR /root
ENTRYPOINT ["/entrypoint.sh"]
CMD ["deepseek-cursor-proxy"]
