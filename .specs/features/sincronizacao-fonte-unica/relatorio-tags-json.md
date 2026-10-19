# Realização

Correção posterior: consulta e confirmação agora precedem a leitura da fonte. Recusar um caso existente permite continuar sem possuir sua unit local. SincronizarCasoTeste retorna a decisão e o ID; AtualizarCasoTeste (nome anterior QuestionarParaRodarUpdateCasoTeste) grava somente depois da validação. Não foram criados novos métodos.

Preservadas as tags camposDisponiveis e resultadoEsperado no caso completo e nos campos separados do registro. parametros não é criado quando ausente. O resolvedor limita a leitura a duas tentativas. O comparador lê resultadoEsperado com tag e continua aceitando registros anteriores.

# Fontes modificados

- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas
- docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas
- .specs/features/sincronizacao-fonte-unica/spec.md
- .specs/features/sincronizacao-fonte-unica/validation.md
- .specs/features/sincronizacao-fonte-unica/evidencias/testar.mjs
- .specs/features/sincronizacao-fonte-unica/evidencias/verificar-independente.mjs
- .specs/features/sincronizacao-fonte-unica/evidencias/sensor-independente.mjs
- .specs/features/sincronizacao-fonte-unica/relatorio-tags-json.md

# p/ teste

Confirmação: três grupos adicionais aprovados, revisão independente aprovada e sensor atualizado com quatro mutações detectadas. No ERP, responder Não para um caso existente sem fonte local deve permitir seguir para o próximo. Responder Sim continua exigindo a fonte válida. Este teste nativo ainda não foi executado.

Validação local: dez grupos principais e quatro complementares aprovados, revisão independente aprovada, três mutações detectadas. Nenhuma execução no ERP ou escrita em banco.

Na próxima execução autorizada no ERP, conferir o caso completo e os campos separados. Sem parametros na fonte, a propriedade deve continuar ausente. resultadoEsperado vazio deve permanecer vazio e apenas gerar log de ausência de validação. Sem resultadoEsperado, deve entrar o mínimo remoto. camposDisponiveis ausente ou vazio deve usar o mínimo remoto. Com configurações preenchidas, conferir sua preservação e a execução das verificações.

# O que há de novo

O JSON registrado conserva as propriedades de configuração, seguindo o modelo dos desenvolvedores, sem acrescentar parâmetros vazios automaticamente.
