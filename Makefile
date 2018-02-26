PROJECTS = $(shell find -maxdepth 1 -type d)

.PHONY: $(PROJECTS)
.ONESHELL:
$(PROJECTS):
	export WORKDIR=$$(mktemp --dry-run --directory --suffix .pkgbuild.${@})
	git clone ssh://aur@aur.archlinux.org/${@}.git $$WORKDIR
	FILES=$$(cd ${@}; git ls-files .)
	cp -r ${@}/* $$WORKDIR/
	COMMIT=$$(git log --pretty=format:'%s' | grep "${@}:" | head -n 1)
	COMMIT=$${COMMIT:-"sync github.com/kovetskiy/pkgbuilds"}
	cd $$WORKDIR
	mksrcinfo
	ls -lah
	grep -P '(pkgver|pkgrel)=' PKGBUILD
	git add $${FILES} .SRCINFO
	git diff
	git status
	echo -n "Proceed? [Y/n]: "
	read proceed
	[[ "$$proceed" != "n" ]] || exit
	git commit -m "$$COMMIT"
	git push origin master

clean:
	@git clean -fX
