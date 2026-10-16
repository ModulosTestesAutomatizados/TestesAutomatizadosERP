import type { IDocumento, TBloco } from '../../../../contracts/documentacao.ts';
const pastaRunner = 'docs/assets/emDesenvolvimento/Runner/';
const paragrafo = (pTexto: string): TBloco => ({ tipo: 'paragrafo', texto: pTexto });
const aviso = (pTexto: string): TBloco => ({ tipo: 'aviso', severidade: 'warning', texto: pTexto });

export default {
  slug: 'runner', categoria: 'estrutura', titulo: 'IRunner.Executar',
  resumo: 'Da montagem do código ao lote de casos: responsabilidades, uses, estado compartilhado, logs e métricas.',
  estado: 'em-desenvolvimento',
  fontes: [
    ...['P39_TDD_IRUNNER', 'P39_TDD_RUNNER', 'P39_TDD_BASE_UNIT_IRUNNER', 'P39_TDD_STARTED', 'P39_TDD_FINISHED', 'P39_TDD_LOGS', 'P39_TDD_FIN_PROCESSAMENTO'].map(pNome => ({ caminho: `${pastaRunner}${pNome}.pas` })),
    { caminho: 'docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas' },
    { caminho: 'docs/MER.md' }, { caminho: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md' }, { caminho: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.ast.json' }
  ],
  secoes: [
    { id: 'contrato', titulo: '01 · Contrato de entrada', blocos: [
      paragrafo('IRunner monta um programa interpretado para uma única unit com entrada Teste sem parâmetros. SetTDDUnit define essa unit; AddParamsRun recebe exatamente dois valores, módulo e área, escritos como literais Pascal. Executar preenche o molde e chama Interpretar uma vez. A carga do lote e o cursor dos casos pertencem ao molde, não à unit Teste.'),
      { tipo: 'codigo', linguagem: 'pascal', codigo: "uses P39_TDD_IRUNNER;\n\nprocedure ExecutarIRunner;\nbegin\n  SetTDDUnit('P39_TDD_FIN_PAGAMENTO_RECEBIMENTO');\n  AddParamsRun('''FINANCEIRO''');\n  AddParamsRun('''FINANCEIRO''');\n  Executar;\nend;" },
      aviso('TDD_ASSERTS e a persistência de METRICAS_ASSERTS continuam pendentes. SUCESSO indica que o caminho implementado terminou sem exceção; não certifica aprovação funcional dos asserts.'),
      paragrafo('Nomenclatura: BASE_UNIT é P39_TDD_BASE_UNIT_IRUNNER.pas. O artefato de casos referido como TDD_CASOS_DE_TESTES está disponível como P39_TDD_CASOS_DE_TESTE.pas, no singular. Os nomes reais dos fontes são preservados nos links.')
    ] },
    { id: 'responsabilidades', titulo: '02 · Responsabilidades e fronteiras', blocos: [
      { tipo: 'mermaid', titulo: 'Responsabilidades do fluxo interpretado', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/responsabilidades.md' },
      paragrafo('IRunner monta; o molde orquestra; Runner prepara o contexto e mede; Started prepara o registro corrente; Teste executa o cenário; Finished persiste a tentativa. LOGS e as dependências de preparação oferecem os artefatos compartilhados. Este desenho representa responsabilidades; as relações uses estão no grafo específico abaixo.')
    ] },
    { id: 'montagem', titulo: '03 · Como Executar preenche o molde', nivel: 3, blocos: [
      { tipo: 'lista', itens: [
        'Valida FTDDUnit não vazia, lista de parâmetros inicializada e exatamente dois parâmetros.',
        "Obtém CodificacaoUnit('P39_TDD_BASE_UNIT_IRUNNER') e mantém o texto em FUnitInterpretar.",
        'Substitui __USES_UNITS__ pela unit definida, __PARAMETROS_CASO_TESTE__ pelos literais módulo/área e __CHAMADAS_METODOS__ pelo bloco de chamada de Teste.',
        'A chamada gerada envolve Teste com callback, delimitador de logs e RegistrarTick(0/1).',
        'Registra o código gerado em modo debug e executa Interpretar(FUnitInterpretar.Text).',
        'O finally libera as listas temporárias e a lista de parâmetros.'
      ] },
      aviso('O molde tem marcadores e não deve ser executado isoladamente. Os fontes fazem Free sem zerar todas as referências; não há evidência local de reentrância ou de chamadas sucessivas de Executar seguras no mesmo contexto do host.')
    ] },
    { id: 'uses', titulo: '04 · Grafo AST dos uses', blocos: [
      paragrafo('O mapa é gerado de uma árvore sintática do subconjunto uses: comentários e strings são reconhecidos para evitar relações falsas; cada aresta conserva arquivo e linha. O inventário registra cláusulas, nós e alcance transitivo. Não é uma AST completa de Delphi nem prova de resolução pelo ERP.'),
      paragrafo('Setas sólidas representam dependências diretas; a sequência de setas expõe herança transitiva. Setas pontilhadas representam CodificacaoUnit e o marcador da unit Teste. Azul identifica fonte local, cinza dependência externa/não resolvida e amarelo marcador dinâmico. Prefixos P39_TDD e TDD permanecem distintos.'),
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md', titulo: 'Dependências declaradas e montagem dinâmica' },
      paragrafo('Os arquivos e linhas de cada relação estão no mapa Markdown e no inventário P39_TDD_IRUNNER.ast.json, disponíveis nas fontes ao final desta página. O desenho mantém a visão das dependências sem repetir todas as arestas em uma tabela.'),
      paragrafo('P39_TDD_FINISHED não declara uses, mas acessa globais e funções do contexto interpretado. Esses acessos são documentados como compartilhamento de estado, não como dependências estáticas inventadas. O piloto financeiro é uma raiz separada do inventário: SetTDDUnit o insere dinamicamente no molde.')
    ] },
    { id: 'lote', titulo: '05 · Fluxo do lote e da tentativa', blocos: [
      { tipo: 'mermaid', titulo: 'Da entrada à persistência', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/lote.md' },
      paragrafo('SetupCasosTestes define módulo/área e carrega os casos uma vez. ExecutarLote é o único dono de First/Next. Run reinicia o contexto, cria o dataset de tempos, abre callbacks, executa Started e o Teste da unit configurada. O finally fecha os tempos ainda abertos e tenta persistir antes do fechamento das telas.'),
      paragrafo('Started aceita requisito de versão vazio; quando informado, exige versão igual ou superior. Lê o JSON do registro corrente, obtém o bloco parametros e chama VerificarParametros. Os parâmetros aplicados são configuração do ERP; finalizar os datasets não implica restaurar os valores anteriores.')
    ] },
    { id: 'falhas', titulo: '06 · Falhas, continuidade e limpeza', nivel: 3, blocos: [
      { tipo: 'mermaid', titulo: 'Decisão após uma exceção', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/falhas.md' },
      paragrafo('Falhas de Teste podem permitir continuidade depois da persistência. Incompatibilidade de versão preserva VERSAO_INCOMPATIVEL e pode permitir o próximo registro. As outras falhas em STARTED e as falhas de TEARDOWN propagam e interrompem o lote. Preparação, persistência e fechamento também podem propagar erros.'),
      paragrafo('Se a limpeza do lote falhar, o bloco interrompe o encerramento e não garante executar as liberações seguintes.'),
      aviso('Persistência é uma tentativa no finally; não há retry automático ou garantia de transação única entre histórico e todos os tempos. Um erro pode deixar registros parciais. O fonte usa VERSAO_INCOMPATIVEL; o MER e materiais legados podem usar INCOMPATIVEL_VERSAO.')
    ] },
    { id: 'estado', titulo: '07 · Estados globais e execuções variáveis', blocos: [
      paragrafo('Os artefatos globais são reutilizados pelo fluxo interpretado. A variação entre casos vem do registro corrente, do JSON e da configuração módulo/área; a unit de Teste continua a mesma dentro de um lote. Compartilhamento de estado não equivale a execução concorrente ou isolamento.'),
      { tipo: 'mermaid', titulo: 'Estado do lote e estado de uma tentativa', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/estado.md' },
      paragrafo('FHistoricoExecucao e FContextoCasoTeste são reiniciados por tentativa. FCasoTesteAtualId e FCasoTesteAtualJson são preenchidos em Started. FCDSMetricasTickDiff é recriado por caso; FEtapaAtual e FNomeMetodoAtual identificam a execução e a etapa de falha.'),
      paragrafo('FLogsCasoTeste recebe Clear no início e no fim de Run e Free no lote. FModoDebug controla mensagens; FExibirInstrucoes controla instruções independentemente. CDSModulos, CDSAreas e os parâmetros permanecem disponíveis no lote. A configuração persistida no ERP não é restaurada automaticamente.'),
      paragrafo('No piloto financeiro, Teste valida FCasoTesteAtualJson e executa duplicata receber, duplicata pagar, borderô receber e borderô pagar. As tags variam por registro. O finally próprio marca TEARDOWN, registra seu tempo e encerra objetos/telas do caso, sem destruir os datasets compartilhados do lote.'),
      { tipo: 'lista', itens: ['Trocar o módulo/área muda a seleção dos casos carregados.', 'Trocar SetTDDUnit muda a implementação de Teste inserida no molde.', 'Variar o JSON do registro modifica entradas e parâmetros do caso sem duplicar o Runner.', 'Units legadas que carregam casos e avançam seu próprio cursor precisam de adaptação antes de entrar nesse contrato.'] }
    ] },
    { id: 'metricas', titulo: '08 · Logs, tempos e persistência', blocos: [
      { tipo: 'mermaid', titulo: 'Da medição à persistência', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/metricas.md' },
      paragrafo('RegistrarTick normaliza o nome em maiúsculas. O início usa GetTickCount e rejeita duplicidade; o fim procura o registro com TEMPO_FIM = 0 e calcula TickDiff e a duração formatada. O ID retornado do histórico vincula todos os tempos da tentativa.'),
      paragrafo('O snapshot de logs é atribuído por Run imediatamente antes de RegistrarMetricas. O resumo do lote é produzido fora da tentativa, depois dos históricos individuais; não presumir que esse resumo foi salvo em cada histórico. A configuração de acesso ao banco dedicado pertence a CONSTANTES/ODBC; a documentação não se conecta ao banco.'),
      aviso('O tempo da etapa ASSERTS mede apenas o trecho reservado, não uma comparação implementada. Os nomes das etapas são chaves de busca de métricas por tentativa. Nenhuma execução no ERP foi feita para homologar este conteúdo.')
    ] }
  ]
} satisfies IDocumento;
