#!/bin/bash -eu
#--------------------------------------
# tmux
#
# Environment Variables:
#   PROV_TMUX_VERSION: tmux version (e.g. "2.1")
#   PROV_TMUX_WITHOUT_PATCHES: without CJK patches if not empty
#   PROV_TMUX_PATCH_HASH: CJK patch hash of the git
#--------------------------------------

: ${PROV_TMUX_VERSION:=${1:-2.1}}
: ${PROV_TMUX_WITHOUT_PATCHES:=}
: ${PROV_TMUX_PATCH_HASH:=}

if [[ -z "$PROV_TMUX_PATCH_HASH" ]]; then
    case "${PROV_TMUX_VERSION}" in
        2.1*) PROV_TMUX_PATCH_HASH=695586f ;;
        2.0*) PROV_TMUX_PATCH_HASH=f1b8fba ;;
        1.9*) PROV_TMUX_PATCH_HASH=6f1aa27 ;;
        1.8*) PROV_TMUX_PATCH_HASH=f9981fe ;;
        *)    PROV_TMUX_PATCH_HASH=master ;;
    esac
fi

yum -y install automake patch libevent-devel ncurses-devel
[[ -d /opt/src ]] || mkdir /opt/src

git clone -b "${PROV_TMUX_VERSION}" https://github.com/tmux/tmux.git /opt/src/tmux
if [[ -n "$PROV_TMUX_WITHOUT_PATCHES" ]]; then
    (cd /opt/src/tmux && \
        ./autogen.sh && \
        ./configure --prefix=/usr/local && \
        make install)
else
    git clone https://gist.github.com/1399751.git /opt/src/tmux-patches
    (cd /opt/src/tmux-patches && git checkout "$PROV_TMUX_PATCH_HASH")
    (cd /opt/src/tmux && \
        ./autogen.sh && \
        patch -p1 </opt/src/tmux-patches/tmux-ambiguous-width-cjk.patch && \
        patch -p1 </opt/src/tmux-patches/tmux-do-not-combine-utf8.patch && \
        patch -p1 </opt/src/tmux-patches/tmux-pane-border-ascii.patch && \
        ./configure --prefix=/usr/local && \
        make install)
fi
