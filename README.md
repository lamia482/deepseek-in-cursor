# 🚀 Cursor调用Deepseek-V4-Pro

### ✅ 前提准备

在开始前，请确认准备好：

- **DeepSeek API Key**：在 [DeepSeek Platform](https://platform.deepseek.com/api_keys) 获取。
- **ngrok Authtoken**：在 [ngrok Dashboard](https://dashboard.ngrok.com/get-started/your-authtoken) 获取（用于免费版动态地址）。
- **网络环境**：确保能正常访问外网。

### 🚀 详细配置步骤「在HOST主机」

```
git clone git@github.com:lamia482/deepseek-in-cursor.git
cd deepseek-in-cursor
cp .env.example .env
# 修改 .env 中的ngrok Authtoken
docker-compose up -d
docker logs -tf -n10 deepseek-cursor-proxy
```

应看到如下提示，并拷贝

alt text

#### 在 Cursor 中配置使用该代理

1. 打开 Cursor 编辑器，按下快捷键 `Cmd/Ctrl + ,` 打开设置。
2. 找到 `Models` 页面，点击 **"+ Add Custom Model"** 添加一个新的自定义模型。
3. 填入以下信息：

- 

- **Model Name**: `deepseek-v4-pro` (或其他你想用的DeepSeek模型名)
- **Base URL**: 填入上一步终端里显示的 ngrok 地址，并在末尾加上 `/v1`。例如：`https://xxxx-xxx-xx-xxx.ngrok-free.dev/v1`
- **API Key**: 填入你在 DeepSeek 官网获取的 API Key。

#### 开始使用

在 Cursor 的 AI 聊天窗口，从模型下拉菜单里选择你刚添加的模型（例如 `deepseek-v4-pro`），然后就可以像使用官方模型一样愉快地提问了。

自定义的模型无法和 Cursor 内置的模型共用，需要先关闭「OpenAI API Key」之后选择别的模型；