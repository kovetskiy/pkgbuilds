PROJECTS = $(shell find -maxdepth 1 -type d)

.PHONY: $(PROJECTS)
.ONESHELL:
$(PROJECTS):
	WORKDIR=$$(mktemp --dry-run --directory --suffix .pkgbuild.${@})
	git clone ssh://aur@aur.archlinux.org/${@}.git $$WORKDIR
	cp -r ${@}/* ${@}/.* $$WORKDIR
	COMMIT=$$(git log --pretty=format:'%s' | grep "${@}:" | head -n 1)
	COMMIT=$${COMMIT:-"sync github.com/kovetskiy/pkgbuilds"}
	cd $$WORKDIR
	ls -lah
	mksrcinfo
	git add .
	git diff
	echo -n "Proceed? [Y/n]: "
	read proceed
	[[ "$$proceed" != "n" ]] || exit
	git push origin master

clean:
	@git clean -fX
