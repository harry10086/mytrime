# 同文输入法经典主题+雾凇拼音+中英文释义
## 方案说明
本方案支持 Android 系统 [同文输入法：https://github.com/osfans/trime](https://github.com/osfans/trime)：
1. 雾凇拼音+中英文释义+Markdown 语法输入；
2. 优化了主题，移除右下角中英文切换键，数字键和字符键合一，加长空格与回车键；
3. 中英文释义纵向展示候选词时，空格键左右滑动为候选词翻页；
4. 复制了几款经典输入法的主题配色：苹果，搜狗，微信等；

## 雾凇拼音+中英文释义+Markdown 语法输入
[为雾凇拼音添加中英互译释义：https://mianao.info/add-chinese-english-translation-to-rime-ice/](https://mianao.info/add-chinese-english-translation-to-rime-ice/) 
这里介绍了雾凇拼音添加中英文释义，Markdown 语法输入。

[同文输入法](https://github.com/osfans/trime) 是支持 RIME 的开源中文输入法，之前我改的雾凇拼音可以直接移植到同文输入法中，虽然体验稍有差异。

这是同文输入法 APP 的文件目录结构，`rime` 文件夹会自动同步外部配置的用户文件夹内容，**切记不要动去另外一个文件夹 `shared` 的文件**：
![data](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/data.webp)

在 Android 系统根目录新建文件夹 rime，根据需要将修改好的文件复制到目录下：
![rime](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/rime.webp)

**文件列表：**
- **classic.trime.yaml**：# 同文输入法经典主题配置文件。
- **rime_ice.schema.yaml**  # 全拼方案
- **rime_ice.dict.yaml**    # 全拼挂载词库
- **rime_ice.custom.schema.yaml** # 全拼自定义方案
- **double_pinyin\*.yaml**   # 双拼方案
- **melt_eng.schema.yaml**  # 英文方案，作为次翻译器挂载到拼音方案
- **melt_eng.dict.yaml**    # 挂载词库
- **radical_pinyin.schema.yaml**  # 部件拆字方案，作为反查挂载到拼音方案
- **radical_pinyin.dict.yaml**    # 部件拆字词库
- **custom_phrase.txt**    # 自定义短语
- **symbols_v.yaml**       # 全拼 v 模式
- **symbols_caps_v.yaml**  # 双拼 V 模式
- **opencc/**              # 词语映射，Emoji，中英，英中词典等
- **lua/**                 # 各个 Lua 脚本
- **cn_dicts**             # 词库目录
- **en_dicts/**             # 词库目录

## 主题修改
主题来自 fork 的 `chwt163/mytrime` 几个主题的其中一个： `classic.trime.yaml` ，我根据自己的需求和审美做了一些修改：
![color](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/color.webp)

1. 移除右下角中英文切换键，数字键和字符键合一，加长空格与回车键
键位功能整合，将原先分开的符号键与数字键合并为一个复合功能键（位于第四行最左侧）：
- **点击（单击）**：触发 `liquid_keyboard_cn1`（中文模式） / `liquid_keyboard_ascii1`（英文模式），调出符号键盘；
- **长按**：触发 `Keyboard_number`，切换至数字键盘；
- **上滑**：同时绑定了 `swipe_up: Keyboard_number`，无需等待长按耗时，手指在键位上向上轻扫即可秒开数字键盘；
- **角标提示**：添加了小角标 `label_symbol: '123'`，主图标为符号图标，右上角带 `123` 提示，直观表明长按/上滑的功能。

> [!TIP]
> 去除右下角中英切换键后，如需在中英文之间切换，可直接使用第三行最左侧的 **`Shift` 键**（标准 Rime / 同文切换方式）。

2. 增大候选词上方拼音字母区的高度与触控热区
- **原因**：同文输入法的预编辑区（`preedit`）位于键盘顶部边缘，原配置中的字体大小仅为 `font_size: 16`，由于视图采用紧凑排版，导致字母高度仅有约 20~24dp。手指触摸时稍有偏上就会超出输入法窗口范围，从而点击到外部应用。
- **修改位置**（第 90~95 行 `preedit`）：
  ```yaml
  preedit:                  # 预编辑文本视图参数
    horizontal_padding: 12    # 横向内边距（适当加大避免首尾字母太贴边）
    top_end_radius: 0         # 末上端圆角
    foreground:               # 前景样式
      font_size: 22             # 预编辑字号由 16 调大至 22
  ```

3. 空格键左右滑动为候选词翻页，因为翻页键实在太小了
- **取消了预选光标调节**：将 `space` 和 `space3`（英文空格）中的 `slide_cursor` 设为了 `false`。
- **将左右滑动绑定为候选词翻页**：
   - **向左滑动**：上一页（`Page_Up`）
   - **向右滑动**：下一页（`Page_Down`）

- **对应关键代码变更**：
  - **按键布局位置** `第 1119 行`：
  ```yaml
  - {click: space, ascii: space3, slide_cursor: false, long_click: , swipe_left: Page_Up, swipe_right: Page_Down, width: 40, ...}
  ```
  - **按键全局预设**`第 4090、4094 行`：
  ```yaml
  space: {label: '', slide_cursor: false, swipe_left: Page_Up, swipe_right: Page_Down, send: space}
  space3: {label: '_______', slide_cursor: false, swipe_left: Page_Up, swipe_right: Page_Down, send: space}
  ```

4. 减小键盘下方多余空白

① 主题配置层面（已写入配置）
在 `style` 节点中明确将底部边距锁为 0（第 58~59 行）：
```yaml
  keyboard_padding_bottom: 0 # 锁定竖屏键盘底边距为0（消除主题层面的底部垫高）
  keyboard_padding_land_bottom: 0 # 锁定横屏键盘底边距为0
```
② 同文 App 全面屏手势设置
在现代 Android 全面屏手机上，输入法底部有一大截空白通常是**系统手势底栏垫高（防误触边距）**导致的。若修改主题后底部依然偏高，建议在手机上的同文输入法 App 内做如下设置：
  * 打开同文输入法 App -> **设置** -> **高级设置** -> 开启 **「忽略系统手势边衬区」**。
  ![advanced](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/advanced.webp)

  * 进入 **设置** -> **主题设置（或界面设置）** -> **「导航栏背景」** 设置为 **「无背景」** 或 **「跟随键盘背景色」**。

5. 复制了几款经典输入法的主题配色
  - 苹果原生
  ![apple](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/apple.webp)
  - 搜狗经典
  ![sougou](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/sougou.webp)
  - 微信
  ![weixin](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/weixin.webp)
  - 微信暗黑

## 使用方法
1. 复制 `rime` 文件夹到 Android 手机根目录（根据需要，比如我只用全拼，其他 double 的文件就不复制过去）；

2. 打开 同文输入法 -> `设置` -> `配置` -> 将用户文件夹路径指向前面复制的 rime 文件夹，接着点击 `立即同步用户数据`；
![config](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/config.webp)

3. 返回到`设置`首页 -> `方案` -> `添加` -> 选择 `雾凇拼音`；
![plan](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/plan.webp)

4. 返回到`设置`首页 -> 进入 `设置` -> `键盘样式` -> `主题` -> `经典`，再进入 `配色` 选择；
![theme](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/theme.webp)

![colors](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/colors.webp)

5. 根据需要，在 `设置`首页 -> 进入 `候选窗口` -> `候选词窗口`，`设置候选词列表布局`，`候选词窗口位置`；
![candidate](https://github.mianao.info/https://raw.githubusercontent.com/harry10086/picx-images-hosting/master/Trime/candidate.webp)

**添加双拼方案**：
双拼方案在手机上我测试是无法正常部署（AI 说原因是因为手机在首次编译庞大的双拼 prism 时，极易因内存不足（OOM）或超时导致后台编译静默失败/中断），需要先在电脑端预编译后再拷入手机：
1. 在电脑端配置好你的雾凇拼音文件，并勾选你需要的双拼方案，重新部署。
2. 部署完成后，在电脑的用户目录里 build 文件夹中会生成以下二进制文件：

> double_pinyin_\*\.bin
> double_pinyin_*.schema.yaml

3. 将所有文件复制到手机 APP 的 `files/rime/build/` 目录里，再在手机上打开 `Trime` 点击**重新部署**。
4. 返回到`设置`首页 -> `方案` -> `添加` -> 选择 `**双拼`。

> [!TIP]
> 修改完成后，App 会自动部署，如果没生效，可手动点击右上角逆时针旋转的图标 **「重新部署」**。

---

## 修改记录
**2026.9.15：**
### 一、增加每个按键面积（防误触）
按键的物理触摸面积和间距主要由文件开头的 **`height`** 和 **`style`** 参数决定：
1. **增大单行按键高度 (`key_height`)**：
   - 当前主键盘按键高度 `jpgd4` 为 `48`，可调整为 `52 ~ 56`。
2. **缩小按键缝隙 (`horizontal_gap` 与 `vertical_gap`)**：
   - 将横向缝隙从 `3` 缩小为 `1.5 ~ 2`，竖向行距从 `7` 缩小为 `3 ~ 4`。缝隙缩减出来的空间会直接变成按键的实体面积。
3. **配合增大总键盘锁定高度 (`keyboard_height`)**：
   - 单键高度增加后，建议将锁定的 `keyboard_height` 从 `220` 提升至 `245 ~ 260`，防止键盘内容被底部裁剪。

```yaml
# 键盘高度与缝隙定义（约第 13~20 行）
height:
  1: &jpgd1 30
  2: &jpgd2 24
  3: &jpgd3 24
  4: &jpgd4 54      # 【修改】主键盘单键高度由 48 调大至 54
  5: &jpgd5 39.5
  6: &hgap 1.5      # 【修改】横向缝隙由 3 缩减至 1.5（按键变宽）
  7: &sgap 4        # 【修改】竖向缝隙由 7 缩减至 4（按键变高）

style:
  keyboard_height: 250   # 【修改】总键盘高度由 220 增大至 250
  key_text_size: 24      # 【可选】按键字母字号由 22 增大至 24，视觉更清晰
```

### 二、将左下角按键改为「短按数字，长按符号」
该按键位于 `preset_keyboards.default` 的第 4 行第 1 键（第 1059 行）。
#### 原配置：
```yaml
- {click: liquid_keyboard_cn1, ascii: liquid_keyboard_ascii1, long_click: Keyboard_number, swipe_up: Keyboard_number, label_symbol: '123', width: 20, key_text_size: "20", symbol_text_size: 9, key_symbol_offset_x: 14, key_symbol_offset_y: 0, key_back_color: c3, key_text_color: tenter, key_border: 0}
```

#### 修改后配置：
```yaml
- {click: Keyboard_number, long_click: liquid_keyboard_cn1, ascii_long_click: liquid_keyboard_ascii1, swipe_up: liquid_keyboard_cn1, label: '123', label_symbol: '符', width: 20, key_text_size: "20", symbol_text_size: 9, key_symbol_offset_x: 14, key_symbol_offset_y: 0, key_back_color: c3, key_text_color: tenter, key_border: 0}
```
- **功能变更**：
  - **短按**：直接切到数字键盘 (`Keyboard_number`)，主显示为 `123`；
  - **长按 / 上滑**：切到符号键盘 (`liquid_keyboard_cn1`)，右上角角标提示为 `符`。

---

## 附原作者其他主题
### 同文皮肤主题的修改教程：
[trime.yaml詳解](https://github.com/mrhso/trime/wiki/trime.yaml%E8%A9%B3%E8%A7%A3)

### 其他主题截图
<img width="720" height="2213" alt="color trime" src="https://github.com/user-attachments/assets/2fc76b8a-4a37-4198-9459-adacbbcde6ab" />

![Screenshot_2025-11-16-14-23-17-20_5cd225ada6153df039aa0f4408fcc4ec](https://github.com/user-attachments/assets/3b288613-5299-41a4-b550-c51fb9caae36)

<img width="720" height="2368" alt="Screenshot-2" src="https://github.com/user-attachments/assets/427d2f51-123d-403e-b1ba-8ee052dcc77c" />

![Screenshot_2025-11-16-14-26-49-43_5cd225ada6153df039aa0f4408fcc4ec](https://github.com/user-attachments/assets/641bd1bf-7f48-43a9-87cf-f88a63d991e2)