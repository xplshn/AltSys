#!/bin/ksh

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Updated content reflecting changes from SOURCES file
printf '%b' "${RED}[anto@beef ~/Documents]@ cat dev/AltSys/opt/SOURCES${NC}\n"
printf '%b' "${GREEN}core:${NC} doas                            : ${CYAN}https://github.com/slicer69/doas${NC}        |${BLUE}commit: e9bee5f17210a97a40c6cdc130740fa2d70f9b0e${NC}\n"
printf '%b' "${YELLOW}misc:${NC} fortune                         : ${CYAN}https://github.com/cafkafk/fortune-kind${NC} |${BLUE}commit: 120798bf41c5b0b28fdd9025bf8b1ebe2d2193c7${NC}\n"
printf '%b' "${YELLOW}misc:${NC} pfetch                          : ${CYAN}https://github.com/OldWorldOrdr/pfetch${NC}  - MODIFIED artwork from this PR: ${CYAN}https://github.com/OldWorldOrdr/pfetch/pull/7${NC}\n"
printf '%b' "${YELLOW}misc:${NC} awk                             : ${CYAN}https://github.com/onetrueawk/awk${NC}       |${BLUE}commit: 8424e93ad3e63cdfda1ae34e984691c3fe879175${NC}\n"
printf '%b' "${YELLOW}misc:${NC} cowsay & cowthink implementation: ${CYAN}https://gitlab.com/nmyk/cowsay${NC}          |${BLUE}commit: cca7d2f52ae34625d6230cfd537ff5d5cba0a57d${NC}\n"
printf '%b' "${YELLOW}misc:${NC} ccat, ttts                      : ${CYAN}https://github.com/xplshn/Handyscripts${NC}  |${BLUE}commit: 11a19060c009bb82170bdc8edf9e4c4b5c780be8${NC}\n"
printf '%b' "${GREEN}coreutils:${NC} Toybox: ${CYAN}https://github.com/landley/toybox${NC}                            |${BLUE}commit: ab046139f9d83136ff1cb143ee5923b3ee22a972${NC}\n"
printf '%b' "${GREEN}coreutils:${NC} Ubase : ${CYAN}https://git.suckless.org/ubase/${NC}                       |${MAGENTA}commit-date: 2023-09-22 08:06${NC}\n"
printf '%b' "${GREEN}coreutils:${NC} Sbase : ${CYAN}https://git.suckless.org/sbase/${NC}                       |${MAGENTA}commit-date: 2023-12-01 12:33${NC}\n"
printf '%b' "${RED}________________________________________2023-12-15${NC}\n"
printf '%b' "${YELLOW}Info:${NC} The coreutils are used in this order: if \$COMMAND is provided by ubase, but also by sbase, and also by toybox, the system will use Toybox's, if the command is provided only by sbase, or ubase, the system will use that, same goes for toybox, if the command is not found on /opt/AltSys/*/*, the system will fallback to the commands on /bin, /usr/bin, etc. See /etc/profile\n"
