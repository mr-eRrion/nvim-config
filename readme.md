# Neovim 配置说明书

快速入口：
- 详细使用指南：`usage.md`

这是我的个人 Neovim 配置，基于 `lazy.nvim` 管理插件，偏向科研写作与开发混用：Typst / LaTeX、调试、格式化、Git、Telescope 与一组常用编辑增强。

---

## 安装与启动

1. 安装 Neovim（建议 0.9+，0.10+ 更佳）。
2. 将本项目克隆到 `~/.config/nvim`。
3. 启动 `nvim`，首次会自动下载插件。

> 注意：首次安装会从 GitHub 拉取插件，需要可用网络环境。

---

## 目录结构

- `init.lua`：入口，按模块加载配置
- `lua/plugins.lua`：插件列表与 lazy.nvim 引导
- `lua/*-conf.lua`：各插件配置
- `lua/preferences.lua`：键位与基础选项
- `lua/util/*`：Typst 辅助工具
- `after/ftplugin/typst.lua`：Typst 文件的额外命令
- `luasnip/typst/*.lua`：Typst 自定义片段

---

## 必备/推荐依赖

**基础**
- `git`：拉取插件
- Nerd Font：图标显示（如 NvimTree、lualine）

**语言与工具**
- `node`：Copilot / CopilotChat
- `typst`：Typst 编译
- `latexmk` + PDF 查看器（Skim 或 Zathura）：VimTeX
- `ruff`：Python 格式化（formatter.nvim）
- `gdb`：C/C++ 调试（nvim-dap）
- `debugpy`：Python 调试（通过 Mason 安装）

**UI 与扩展**
- `fortune`：Alpha 启动页随机文本
- `imagemagick`（`magick`/`convert`）与 Kitty：image.nvim 渲染图片
- `xclip` 或 `wl-clipboard`：系统剪贴板（Linux）

---

## 插件概览

**编辑与 UI**
- `nvim-tree`：文件树
- `bufferline`：标签页样式
- `lualine`：状态栏
- `catppuccin`：主题
- `alpha-nvim`：启动页
- `which-key`：键位提示

**搜索与导航**
- `telescope` + `telescope-project` + `telescope-file-browser`

**Git**
- `gitsigns`
- `neogit` + `diffview`

**代码智能**
- `nvim-lspconfig` + `mason` + `mason-lspconfig`
- `nvim-cmp` 自动补全
- `LuaSnip` 片段
- `nvim-treesitter` 语法高亮

**调试/格式化**
- `nvim-dap` + `nvim-dap-ui`
- `formatter.nvim`

**写作与特殊文件**
- `vimtex`（LaTeX）
- `typst-preview.nvim`（Typst 预览）
- `render-markdown.nvim`（Markdown 增强）
- Typst 自定义 snippets + build 命令

**其他**
- `Comment.nvim`
- `trouble.nvim`
- `img-clip.nvim` + `image.nvim`
- `iron.nvim`（REPL）
- `copilot.vim` + `CopilotChat.nvim`
- `im-select.nvim`
- `texpresso.vim`（自定义 texpresso 路径）

---

## 常用快捷键

> `<Leader>` 默认为空格（Space）。如需修改可在 `lua/preferences.lua` 中调整。

**窗口**
- `<C-Left/Down/Up/Right>`：切换窗口

**文件树**
- `<Leader>ls`：`NvimTreeToggle`

**Telescope**
- `<Leader>ff`：查找文件
- `<Leader>fp`：项目切换
- `<Leader>fg`：全局搜索
- `<Leader>fs`：文档符号
- `<Leader>fb`：文件浏览器
- `<Leader>se`：当前缓冲区模糊搜索

**终端**
- `<Leader>tv`：右侧终端
- `<Leader>ts`：下方终端

**诊断**
- `<Leader>sd`：浮窗显示诊断信息

**格式化**
- `<Leader>fm`：`Format`
- `<Leader>fw`：`FormatWrite`

**DAP 调试**
- `<F5>`：继续
- `<F10>`：步进
- `<F11>`：步入
- `<F12>`：步出
- `<Leader>b`：切换断点
- `<Leader>B`：设置断点
- `<Leader>lp`：日志断点
- `<Leader>dr`：打开 REPL
- `<Leader>dl`：重复上次调试
- `<Leader>da`：切换 DAP UI

**重命名**
- `<Leader>rn`：LSP 重命名

**CopilotChat**
- `<Leader>co`：打开 CopilotChat（普通/可视模式）

**Neogit**
- `<Leader>gi`：打开 Neogit

**Trouble**
- `<Leader>xx`：诊断列表
- `<Leader>xX`：当前缓冲区诊断
- `<Leader>cs`：符号列表
- `<Leader>cl`：LSP 定义/引用
- `<Leader>xL`：Location List
- `<Leader>xQ`：Quickfix List

**iron.nvim（REPL）**
- `<space>rs`：打开 REPL
- `<space>rr`：重启 REPL
- `<space>rf`：聚焦 REPL
- `<space>rh`：隐藏 REPL
- `<space>sc`：发送选区/移动
- `<space>sf`：发送文件
- `<space>sl`：发送行
- `<space>sp`：发送段落
- `<space>su`：发送至光标
- `<space>sm`：发送标记
- `<space>mc`：标记区块
- `<space>md`：移除标记
- `<space>cl`：清屏

**终端模式**
- `<Esc>`：退出终端模式

---

## LSP 与补全

- 使用 `mason.nvim` 管理 LSP/调试器。
- 打开 `:Mason` 安装语言服务器。
- 自动补全由 `nvim-cmp` 驱动，支持 LSP、buffer、路径。

---

## 格式化

通过 `formatter.nvim` 提供：
- Lua：`luaformat`
- Python：`ruff`
- 通用：清理行尾空格

---

## 调试

**Python**
通过 `debugpy`，使用 Mason 安装包：`:MasonInstall debugpy`。

**C/C++**
使用 `gdb`，提供启动、附加与 gdbserver 配置。

---

## Typst

**预览**
`typst-preview.nvim` 已启用，`open_cmd = "open %s"`（macOS）。

**构建**
`after/ftplugin/typst.lua` 提供命令：
- `:TypstBuild`：调用 `typst compile`，输出 quickfix 信息。

**自定义 Snippets**
位于 `luasnip/typst/`，覆盖：
- 数学模式下的分式、上下标、根号、求和、积分等
- 字体与样式（bold/italic/calligraphic 等）
- 常用符号与括号

依赖 `nvim-treesitter` 的 Typst 解析树来判断数学环境。

---

## LaTeX / VimTeX

`lua/vimtex.lua` 中设置：
- `vimtex_view_method = 'skim'`
- `vimtex_compiler_method = 'latexmk'`
- Skim SyncTeX 自动同步

> 如果想使用 Zathura，请在 `lua/vimtex.lua` 中调整 `vim.g.vimtex_view_method`。

---

## Markdown 与图片

- `render-markdown.nvim`：渲染 LaTeX 公式
- `img-clip.nvim`：`<Leader>pi` 粘贴剪贴板图片
- `image.nvim`：依赖 Kitty + ImageMagick

---

## texpresso

`lua/plugins.lua` 会自动探测 `texpresso` 可执行文件并设置 `require('texpresso').texpresso_path`，查找顺序为：
1) 环境变量 `TEXPRESSO_PATH`（非空即用）
2) 如果存在 `~/texpresso/build/texpresso` 则使用该路径
3) 若 `texpresso` 在系统 `PATH` 中，则使用 `vim.fn.exepath('texpresso')`
4) 否则保持未设置（你需要手动提供路径）

你可以通过设置环境变量来覆盖，例如在 shell 配置中加入：
```sh
export TEXPRESSO_PATH=/absolute/path/to/texpresso
```

---

## 备注

- Tree-sitter 的部分语言需要安装 `tree-sitter` CLI。
- `vim.g.copilot_enabled = false` 默认关闭 Copilot，可手动打开。
