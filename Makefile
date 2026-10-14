# 南方科技大学数学系 Beamer 模板 —— 统一入口
# 编译参数见 .latexmkrc, 格式化约定见 tex-fmt.toml

NAME := main
TEX := $(wildcard *.tex)
LOG := cache/$(NAME).log
PAGES := pdfinfo $(NAME).pdf | awk '/^Pages/{print $$2}'

.DEFAULT_GOAL := all
.PHONY: all run watch fmt lint verify clean help

all: run

run: ## 编译生成 main.pdf
	@latexmk -silent || { \
		printf '\n\033[31m✗ 编译失败\033[0m —— %s 中的错误:\n' $(LOG); \
		grep -E '^!|^[^ ]*\.tex:[0-9]+:' $(LOG) | head -15; \
		exit 1; }
	@printf '  \033[32m✓\033[0m %s.pdf (%s 页)\n' $(NAME) "$$($(PAGES))"

watch: ## 监听源文件改动并自动重编译 (Ctrl-C 退出)
	@latexmk -pvc -silent

fmt: ## 按 tex-fmt 规范格式化源码
	tex-fmt $(TEX)

lint: ## 检查源码格式是否符合 tex-fmt 规范 (不改文件)
	tex-fmt --check $(TEX)

verify: run ## 编译并检查日志中的错误与告警
	@rc=0; \
	for pat in '\.tex:[0-9]*:' 'Overfull' 'Underfull' 'Missing character' 'Font shape .* undefined'; do \
		n=$$(grep -Ec "$$pat" $(LOG) 2>/dev/null || true); \
		if [ "$$n" = 0 ]; then printf '  \033[32m✓\033[0m %s\n' "$$pat"; \
		else printf '  \033[31m✗\033[0m %s (%s 处)\n' "$$pat" "$$n"; rc=1; fi; \
	done; \
	exit $$rc

clean: ## 清理编译产物 (保留源码)
	@latexmk -C >/dev/null
	@rmdir cache 2>/dev/null || true
	@printf '  \033[32m✓\033[0m 已清理\n'

help: ## 显示本帮助
	@grep -E '^[a-z]+:.*?## ' $(MAKEFILE_LIST) \
		| awk -F':.*?## ' '{printf "  make %-8s %s\n", $$1, $$2}'
