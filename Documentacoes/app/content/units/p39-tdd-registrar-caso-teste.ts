import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

const documento = criarDocumentoUnit({
  nome: 'P39_TDD_REGISTRAR_CASO_TESTE',
  navegacao: { grupo: 'helpers', subgrupo: 'sincronizacao', ordem: 0 },
  resumo: 'Lê os JSONs das units e registra ou atualiza um caso no banco dedicado ao TDD.',
  fonte: 'docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas',
  responsabilidade: 'Montar FCasoTeste, localizar ou criar módulo e área e persistir o caso de teste com comandos parametrizados.',
  problema: 'Centralizar o cadastro dos casos vindos de fontes locais ou remotos, sem duplicar as regras de insert e confirmação de atualização.',
  estados: [
    ['FCasoTeste: TCasoTeste', 'Record com módulo, área, descrição, versão e os três conteúdos JSON do caso.', 'Reutilizado a cada chamada de RegistrarCasoTeste. A unit não o limpa após inserir, atualizar, cancelar ou falhar. Não é o record do caso corrente preparado pelo Started.']
  ],
  metodos: [
    ['procedure Main', 'Exibir as instruções da unit.', 'Chama MostrarInstrucoesUnit pelo contexto de P39_TDD_ODBC e suas dependências. Não registra casos.'],
    ['procedure RegistrarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pRequisitoVersao, pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis, pUnitJsonResultadoEsperado: string; pSincRemoto: boolean)', 'Orquestrar o cadastro de um caso.', 'Cria três TStringList, carrega os conteúdos, obtém módulo e área com fallback habilitado, preenche FCasoTeste e chama SincronizarCasoTeste. O finally libera as listas; não restaura o record global nem desfaz gravações anteriores.'],
    ['function CarregarConteudoUnit(pNomeUnit: string; pSincRemoto: boolean): string', 'Ler o conteúdo de uma unit JSON.', 'Inicia Result com {}. Nome vazio retorna esse objeto. Se pSincRemoto for true, acrescenta cPrefixoSincRemoto antes de CodificacaoUnit. Qualquer exceção de leitura é silenciada e mantém {}. O conteúdo retornado não é validado como JSON.'],
    ['procedure SincronizarCasoTeste', 'Decidir entre inclusão e atualização.', 'Consulta CASO_TESTE pela combinação descrição, módulo e área. Código maior que zero chama QuestionarParaRodarUpdateCasoTeste; caso contrário chama InsertCasoTeste. A decisão depende dos dados do record global.'],
    ['procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste: integer)', 'Solicitar confirmação antes de sobrescrever um caso.', 'Mostra MessageDlg com Sim/Não. Apenas mrYes executa UPDATE parametrizado dos sete campos usando o código como filtro. Recusar retorna sem alterar o caso existente; não retorna um indicador de cancelamento ao chamador.'],
    ['procedure InsertCasoTeste', 'Inserir o caso com os dados de FCasoTeste.', 'Executa INSERT em CASO_TESTE via P39_TDD_ODBC.TDDCommandODBCP. AUTOINC_CT é atribuído pela trigger do banco. JSONs são parâmetros sem QuotedStr para não introduzir aspas literais no conteúdo.'],
    ['function RegistroFallbackBase(pSqlSelect, pSqlInsert: string; pParametrosSql: OleVariant; pAtivarFallback: boolean): integer', 'Consultar um identificador e opcionalmente criar o registro ausente.', 'Usa TDDScalarODBCP, converte o retorno para string e trata vazio ou zero como ausência. Com fallback ativo executa INSERT com RETURNING; sem fallback lança exceção. O resultado final usa StrToIntDef com zero como padrão.'],
    ['function RegistroFallbackModulo(pDescricaoModulo: string; pAtivarFallback: boolean): integer', 'Resolver o código do módulo pela descrição.', 'Prepara SELECT e INSERT com RETURNING em MODULO e delega a RegistroFallbackBase. Acrescenta contexto à mensagem em caso de exceção.'],
    ['function RegistroFallbackArea(pCodigoModulo: integer; pDescricaoArea: string; pAtivarFallback: boolean): integer', 'Resolver a área dentro de um módulo.', 'Prepara SELECT por descrição e módulo e INSERT com RETURNING em AREA. Delega o controle de criação ao booleano pAtivarFallback.']
  ],
  implementacao: [
    'TCasoTeste é o tipo do record global FCasoTeste. A tabela abaixo descreve os campos e seus efeitos na persistência.',
    'Os parâmetros pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis e pUnitJsonResultadoEsperado são nomes de unidades de codificação, não o JSON literal.',
    'RegistrarCasoTeste habilita a criação de módulo e área antes de verificar se o caso já existe. Cancelar o UPDATE do caso não desfaz essas criações.',
    'REQUISITO_VERSAO_CT recebe a string fornecida; esta unit não compara a versão com o ERP. O consumidor do caso faz essa verificação.',
    'A unit não abre uma transação para todo o processo nem garante rollback de operações anteriores.'
  ],
  dependencias: ['Uses direto: P39_TDD_ODBC. cPrefixoSincRemoto e os helpers de instrução vêm do contexto compartilhado de suas dependências.', 'P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS chama RegistrarCasoTeste em sequência.'],
  limites: ['Não há execução nem homologação no ERP comprovada por esta documentação.', 'Falhas de leitura podem persistir {} no lugar do conteúdo esperado. Confira os nomes e o ambiente antes de sincronizar.', 'O record global permanece com o último conteúdo atribuído; chamadas concorrentes ou reentrantes não têm isolamento implementado.']
});

documento.secoes.splice(2, 0, { id: 'campos-registro', titulo: 'Campos de TCasoTeste', blocos: [{
  tipo: 'tabela', colunas: ['Campo', 'Tipo', 'Finalidade', 'Impacto no cadastro'], linhas: [
    ['Modulo', 'integer', 'Código do módulo.', 'Compõe a chave de busca do caso e o campo MODULO_CT.'],
    ['Area', 'integer', 'Código da área dentro do módulo.', 'Compõe a chave de busca e o campo AREA_CT.'],
    ['Descricao', 'string', 'Descrição do caso.', 'Compõe a chave de busca e DESCRICAO_CASO_TESTE_CT.'],
    ['RequisitoVersao', 'string', 'Versão mínima informada pelo cadastro.', 'Persistida em REQUISITO_VERSAO_CT, sem validação nesta unit.'],
    ['CasoTeste', 'string', 'Conteúdo da unit JSON do cenário.', 'Persistido em CASO_TESTE_CT; alimenta os dados do teste quando o caso for carregado.'],
    ['CamposDisponiveis', 'string', 'Conteúdo da unit com campos disponíveis.', 'Persistido em CAMPOS_DISPONIVEIS_CT; nome vazio ou leitura inválida resulta em {}.'],
    ['ResultadoEsperado', 'string', 'Conteúdo da unit de resultado esperado.', 'Persistido em RESULTADO_ESPERADO_CT; cadastrar o conteúdo não implementa asserts.']
  ]
}] });
export default documento;
