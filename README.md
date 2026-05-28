# Cursor调用Deepseek-V4-Pro

✅ 前提准备
在开始前，请确认准备好：
● DeepSeek API Key：在 DeepSeek Platform 获取。
● ngrok Authtoken：在 ngrok Dashboard 获取（用于免费版动态地址）。
● 网络环境：确保能正常访问外网。
🚀 详细配置步骤

1. 创建并激活 Conda 环境

为了隔离依赖，建议创建一个新的独立环境。打开你的终端（Terminal）或 Anaconda Prompt，执行以下命令：
bash

# 创建一个名为 deepseek-proxy 的新环境，并指定 Python 版本（例如 3.10）

conda create -n deepseek-proxy python=3.10 -y

# 激活这个新创建的环境

conda activate deepseek-proxy
2. 克隆项目并安装依赖
环境激活后，你的终端提示符前会出现 (deepseek-proxy)，接下来在这个环境下操作。
bash

# 从 GitHub 克隆项目到本地

git clone [https://github.com/yxlao/deepseek-cursor-proxy.git](https://github.com/yxlao/deepseek-cursor-proxy.git)

# 进入项目目录

cd deepseek-cursor-proxy

# 通过 pip 安装项目所需的依赖（这会用到项目中的 requirements.txt 或 pyproject.toml）

pip install -e .
注意：建议使用 pip 而非 conda 来安装依赖，因为 Python 包管理领域 pip 更通用，能确保项目所需的特定版本依赖被正确安装。
3. 配置并启动代理
安装好依赖后，就可以启动代理服务了。
bash

# 1. 配置 ngrok 的认证令牌 (替换 YOUR_NGROK_AUTHTOKEN)

ngrok config add-authtoken YOUR_NGROK_AUTHTOKEN

# 2. 启动代理服务

deepseek-cursor-proxy
启动成功后，你会看到类似这样的信息：
text
Tunnel: [https://xxxx-xxx-xx-xxx.ngrok-free.app](https://xxxx-xxx-xx-xxx.ngrok-free.app)
⚠️ 千万不要关闭这个终端窗口，否则代理服务会中断。

## Docker 部署（推荐）

使用单一 `docker-compose.yml`，在 macOS、Linux、Windows 上命令相同（默认 bridge 网络 + 端口映射）。

### 支持平台

| 平台 | CPU | Docker 镜像架构 |
|------|-----|-----------------|
| Linux | amd64 / arm64 | `linux/amd64` / `linux/arm64` |
| macOS | Intel | `linux/amd64` |
| macOS | Apple Silicon (M1/M2/M3) | `linux/arm64` |
| Windows | x86_64 (Docker Desktop) | `linux/amd64` |

需安装 [Docker Engine](https://docs.docker.com/engine/install/) 或 [Docker Desktop](https://www.docker.com/products/docker-desktop/)。镜像基于官方多架构 `ngrok/ngrok`，本地 `docker compose build` 会自动匹配本机架构。

### 前置条件

- DeepSeek API Key：在 Cursor 自定义模型中配置（不由容器提供）
- ngrok Authtoken：在 [ngrok Dashboard](https://dashboard.ngrok.com) 获取
- 宿主机 **9000**、**4040** 端口未被占用

### 启动步骤

```bash
# 1. 配置 ngrok token
cp .env.example .env
# 编辑 .env，将 NGROK_AUTHTOKEN 改为你的 token

# 2. 构建并启动
docker compose up --build -d

# 3. 查看公网隧道地址
docker compose logs -f deepseek-proxy
```

日志中会出现 ngrok 公网 URL。在 Cursor 自定义模型中：

- **Base URL**：`https://xxxx.ngrok-free.app/v1`（以日志为准，需带 `/v1`）
- **API Key**：你的 DeepSeek API Key
- **Model**：`deepseek-v4-pro` 或 `deepseek-v4-flash`

### 健康检查与调试

```bash
curl -s http://127.0.0.1:9000/healthz
# ngrok Web UI（可选）
open http://127.0.0.1:4040
```

### 数据持久化

配置与 reasoning 缓存保存在 Docker volume `deepseek-proxy-data`（容器内 `~/.deepseek-cursor-proxy`）。删除 volume 会清空缓存：

```bash
docker compose down -v
```

### 网络说明

本方案使用 **bridge + `ports` 映射**（`9000`、`4040`），未使用 `network_mode: host`，以便同一份 compose 在 macOS / Windows Docker Desktop 上可用（Desktop 不支持真实 host 网络）。代理与 ngrok 子进程在容器内通过 `127.0.0.1:9000` 通信；Cursor 通过 ngrok 公网 URL 访问，不依赖 host 网络。

### 可选：固定 ngrok 域名

在 `docker-compose.yml` 中为服务添加 `command`，例如：

```yaml
command: ["deepseek-cursor-proxy", "--ngrok-url", "https://your-subdomain.ngrok.dev"]
```

### 故障排除

- **构建失败 / pip 错误**：确认能访问 GitHub 与 PyPI；可重试 `docker compose build --no-cache`
- **无 Tunnel URL**：检查 `.env` 中 `NGROK_AUTHTOKEN` 是否正确；查看 `docker compose logs`
- **端口占用**：修改 `docker-compose.yml` 中 `ports` 左侧宿主机端口，例如 `"9001:9000"`
- **Apple Silicon 架构错误**：确保 Docker Desktop 未强制 `linux/amd64` 仿真（除非 intentional）
- **Windows 防火墙**：若本机无法访问 `127.0.0.1:9000`，检查防火墙是否放行 Docker 端口映射

### 停止服务

```bash
docker compose down
```
