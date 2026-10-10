#!/bin/bash
# Acorda o computador do Grok Bot quando a porta 2222 do box para de responder.
# Abre a aba do computador, esconde o app assim que ele aparece, devolve o foco
# e encerra o app depois de QUIT_AFTER segundos.
HOST="${BOX_HOST:-cursor}"
PORT="${BOX_PORT:-2222}"
APP="${BOX_APP:-Grok Bot}"         # nome do processo do app no macOS
INTERVAL="${BOX_INTERVAL:-3}"
QUIT_AFTER="${BOX_QUIT_AFTER:-5}"  # segundos até encerrar o app
COOLDOWN="${BOX_COOLDOWN:-60}"
LOG="$HOME/Library/Logs/box-wake.log"
last=0
log(){ echo "$(date '+%F %T') $*" >> "$LOG"; }
running(){ osascript -e "tell application \"System Events\" to (name of processes) contains \"$APP\"" 2>/dev/null | grep -q true; }
hide(){ osascript -e "tell application \"System Events\" to set visible of process \"$APP\" to false" >/dev/null 2>&1; }
log "start host=$HOST port=$PORT app=$APP"
while true; do
  if ! nc -z -G 2 "$HOST" "$PORT" >/dev/null 2>&1; then
    now=$(date +%s)
    if (( now - last >= COOLDOWN )); then
      front=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
      log "porta fechada; acordando (frente=$front)"
      open "grokbot://app/v1/sidebar?tab=computer"
      for i in $(seq 1 20); do running && break; sleep 0.25; done
      # volta pro app anterior sem esconder o Grok Bot (ele segue aberto atrás)
      for i in 1 2 3; do
        [[ -n "$front" && "$front" != "$APP" ]] && osascript -e "tell application \"$front\" to activate" >/dev/null 2>&1
        sleep 0.3
      done
      sleep "$QUIT_AFTER"
      osascript -e "tell application \"$APP\" to quit" >/dev/null 2>&1
      log "encerrado $APP"
      last=$now
    fi
  fi
  sleep "$INTERVAL"
done
