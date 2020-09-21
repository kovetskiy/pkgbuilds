PROJECTS = $(shell find -maxdepth 1 -type d)

.PHONY: $(PROJECTS)
.ONESHELL:
.SILENT:
$(PROJECTS):
	@cd $@
	@echo :: Building $@
	@makepkg -f -s -i

clean:
	@git clean -fX
