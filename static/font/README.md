# 字体

本地字体 (随模板一起分发):

- [阿里巴巴普惠体](https://alibabafonts.com/#/home) — 中文, `AlibabaPuHuiTi-3-55-Regular` / `-85-Bold`
- [FiraCode](https://github.com/tonsky/FiraCode) — 西文与代码

数学字体来自 TeX Live, 不在本目录:

- Fira Math — `tlmgr install firamath`

  只装在 TeX Live 的 `texmf` 树里、未注册到系统字体库, 因此必须在 `preamble.tex` 里
  按**文件名**加载: `\setmathfont{FiraMath-Regular.otf}`。
  写成字体名 `\setmathfont{Fira Math}` 会报 `fontspec Error: The font "Fira Math"
  cannot be found`。

  Fira Math 缺少花体 (`\mathcal`) 与哥特体 (`\mathfrak`) 字母表, 模板用 STIX Two Math
  补齐这两个区间 (同样来自 TeX Live, `tlmgr install stix2-otf`)。
