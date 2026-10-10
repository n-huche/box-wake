#!/bin/bash
# Mantém o computador do Grok Bot acordado: a cada EVERY segundos abre a aba do
# computador no app, devolve o foco ao app que estava na frente e encerra o
# Grok Bot QUIT_AFTER segundos depois. Se o Grok Bot já estava aberto, só abre a
# aba e não encerra (pra não fechar o app que você está usando).
APP="${BOX_APP:-Grok Bot}"          # nome do processo do app no macOS
EVERY="${BOX_EVERY:-240}"           # segundos entre aberturas (4 min)
QUIT_AFTER="${BOX_QUIT_AFTER:-5}"   # segundos até encerrar o app
LOG="$HOME/Library/Logs/box-wake.log"
log(){ echo "$(date '+%F %T') $*" >> "$LOG"; }
running(){ osascript -e "tell application \"System Events\" to (name of processes) contains \"$APP\"" 2>/dev/null | grep -q true; }
log "start every=${EVERY}s quit_after=${QUIT_AFTER}s app=$APP"
while true; do
  front=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
  was_open=0; running && was_open=1
  open "grokbot://app/v1/sidebar?tab=computer"
  for i in $(seq 1 20); do running && break; sleep 0.25; done
  # volta pro app anterior sem esconder o Grok Bot (ele segue aberto atrás)
  for i in 1 2 3; do
    [[ -n "$front" && "$front" != "$APP" ]] && osascript -e "tell application \"$front\" to activate" >/dev/null 2>&1
    sleep 0.3
  done
  if (( was_open )); then
    log "acordando (frente=$front); $APP já estava aberto, não encerro"
  else
    sleep "$QUIT_AFTER"
    osascript -e "tell application \"$APP\" to quit" >/dev/null 2>&1
    log "acordando (frente=$front); encerrado $APP"
  fi
  sleep "$EVERY"
done
