# box-wake

LaunchAgent do macOS que mantém o computador do Grok Bot (o box) acordado. O box congela depois de ~5 min ocioso; a cada `BOX_EVERY` segundos (padrão 240) o script abre `grokbot://app/v1/sidebar?tab=computer`, devolve o foco ao app que estava na frente e encerra o Grok Bot `BOX_QUIT_AFTER` segundos depois. Se o Grok Bot já estava aberto, ele só abre a aba e não encerra o app.

Com 300 s ainda escapou uma pausa nos testes, por isso o padrão fica abaixo do timer de ociosidade.

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
| `BOX_EVERY` | `240` | segundos entre aberturas da aba do computador |
| `BOX_QUIT_AFTER` | `5` | segundos até encerrar o app (só se ele não estava aberto) |
| `BOX_APP` | `Grok Bot` | nome do processo do app no macOS |

Para mudar, adicione um `EnvironmentVariables` no plist.

Precisa de permissão de Acessibilidade/Automação para o `osascript` controlar o System Events.
