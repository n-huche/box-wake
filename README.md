# box-wake

LaunchAgent do macOS que testa a porta SSH do box (via Tailscale). Se a porta não responder, abre `grokbot://app/v1/sidebar?tab=computer` para acordar a VM, devolve o foco ao app que estava na frente e encerra o Grok Bot alguns segundos depois.

## Instalar

```bash
./install.sh
```

Copia `box-wake.sh` para `~/.local/bin/` e o plist para `~/Library/LaunchAgents/`, e carrega o agente com `launchctl`. Log em `~/Library/Logs/box-wake.log`.

## Desinstalar

```bash
./uninstall.sh
```

## Variáveis

| Variável | Padrão | O que faz |
|---|---|---|
| `BOX_HOST` | `cursor` | host do box no Tailscale |
| `BOX_PORT` | `2222` | porta testada |
| `BOX_APP` | `Grok Bot` | nome do processo do app no macOS |
| `BOX_INTERVAL` | `3` | segundos entre testes |
| `BOX_QUIT_AFTER` | `5` | segundos até encerrar o app depois de acordar |
| `BOX_COOLDOWN` | `60` | intervalo mínimo entre tentativas de acordar |

Para mudar, adicione um `EnvironmentVariables` no plist.

Precisa de permissão de Acessibilidade/Automação para o `osascript` controlar o System Events.
