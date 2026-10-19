# Etapa 06: unit unica e piloto com memoria compartilhada

Data: 2026-10-06. Implementacao local aplicada; gates nativos pendentes.

## Realizacao

TLC atualizado com a autorizacao de renomear AddUsesUnit para SetTDDUnit e remover AddMetodo. Design, tarefas e requisitos refletem a separacao ExecutarLote/Run e as simplificacoes anteriores. A ordem local passou a gerador, chamador e piloto, conforme orientacao do usuario.

IRunner armazena uma unit em string e gera somente Teste no trecho interpretado de Run, com comentario da origem e ticks. Nao chama Teste fora de Interpretar. Dois literais de modulo/area sao concatenados sem CommaText ou troca global de virgulas. Configuracao e listas sao limpas no finally. Chamador financeiro configura somente unit, modulo/area e Executar.

Piloto perdeu exatamente os tres uses, onze constantes e os dois metodos autorizados. Todos os demais metodos foram preservados. Consome FCasoTesteAtualJson, CDSConfiguracao e CDSResultadoEsperado; nao cria datasets de caso/configuracao nem recarrega casos. Wrappers JSON preservados delegam a FUNCOES_JSON. Obrigatorios invalidos/empresa diferente levantam exception antes de gravacoes. As quatro operacoes financeiras seguem a ordem existente, sem seletor local de etapas.

VlrPagar inicia em zero em ambos os borderos; selecao da pessoa e esvaziada por chamada. TearDown existente cancela edicoes e fecha forms financeiros, sem Free em objetos/DS herdados. Pagamento reutiliza os metodos de mapeamento existentes sem criar seus dez datasets temporarios. Ajuste adicional minimo em Run reconhece FNomeMetodoAtual = TEARDOWN para interromper se a limpeza financeira falhar; nenhum flag ou metodo adicional.

STARTED e TDD_RUNNER permaneceram intactas em relacao ao HEAD. FEstruturaCasoTesteIniciada preservada. Asserts nao implementados. Instrucao geral de formatacao permanece pendente; Main do piloto recebeu somente texto coerente com a nova entrada.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas
- docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas (condicao TEARDOWN)
- docs/mapeamentoUses/REFACTOR_TDD_FINANCEIRO_PILOTO.md
- Registros TLC e evidencia estatica em evidencias/codigo-gerado-financeiro.pas.

## p/ teste

Validadores TLC strict passaram sem erros/avisos. Auditoria estrutural passou: inventario de metodos, remocoes exatas, absence de CDS duplicados/recarga/parser local, uso de helpers, ordem das quatro operacoes, acumuladores zerados, selecao reiniciada, limpeza e fase fatal. Composicao estatica extraida da expressao lChamada demonstrou uma chamada a Teste dentro de Run e preservacao de dois pares de literais, incluindo virgula/apostrofo escapado. git diff --check passou. Esses checks nao executam Pascal nem provam o comportamento do JvInterpreter.

Para validacao futura autorizada no BI: confirmar nomes cadastrados e recarregar units; conferir codigo gerado, uma carga/Interpretar, casos com JSONs distintos e historicos individuais; validar obrigatorios, valores decimais e fallbacks; falha individual deve permitir proximo registro e falha de teardown deve interromper. Confirmar segunda execucao com configuracao nova e ausencia de selecao anterior. Executar operacoes financeiras somente na massa de homologacao acordada.

O ERP nao foi executado e nenhum banco foi modificado. Restauracao real de parametros, JSON raiz/objeto e normalizacao, area por modulo e contratos dos mapeamentos continuam pendentes do plano amplo. Nenhuma tarefa ampla foi marcada Verified ou concluida funcionalmente; sem commit de conclusao ou publicacao.

## O que ha de novo

Uma unit configurada, entrada Teste automatica e piloto financeiro reaproveitando o contexto do lote, com menos carga e memoria duplicadas.
