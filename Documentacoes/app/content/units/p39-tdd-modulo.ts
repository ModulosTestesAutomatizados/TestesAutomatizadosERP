import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'faturamento' },
  nome: 'P39_TDD_MODULO', resumo: 'Abre o módulo pelo menu real e recupera o foco da tela após alterações de parâmetros.',
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_MODULO.pas',
  responsabilidade: 'Preparar módulo, configurações e casos de teste e controlar a abertura e o foco do formulário principal no fluxo de Pedido de Venda.',
  problema: 'A recriação isolada de formulários e o Relogar podem deixar o módulo sem foco. A unit centraliza o evento real do menu e a recuperação da janela.',
  estados: [
    ['FDescModulo: String', 'Descrição do módulo recebido por SetModulo.', 'Atualizada ao preparar o módulo.'],
    ['FP: TForm', 'Referência ao FPrincipal usada para abrir a tela e restaurar o foco.', 'Obtida em AbrirTela; não é criada nem liberada pela unit.'],
    ['FMenuName: String', 'Variável declarada, sem uso nas rotinas do fonte incorporado.', 'Não recebe atribuição neste fonte.'],
    ['FModuloDefinido: Boolean', 'Indica que módulo, configuração e casos foram preparados.', 'SetModulo atribui True; não há rotina de reset neste fonte.']
  ],
  metodos: [
    ['procedure SetModulo(pModulo: String)', 'Preparar o módulo e seus registros.', 'Inicializa os datasets por P39_TDD_CASOS_DE_TESTE, define o módulo, carrega configurações e casos e marca FModuloDefinido.'],
    ['procedure AbrirTela(pEventoClickMenu: String)', 'Abrir a tela pelo evento real do menu.', 'Exige FModuloDefinido, obtém FPrincipal e chama o evento recebido com ExecutarMetodoDeObjeto.'],
    ['procedure FocarModulo', 'Devolver o foco ao formulário principal.', 'Executa SetFocus e Repaint sobre FP.'],
    ['procedure TrazerParaFrente', 'Trazer o módulo à frente das demais janelas.', 'Executa BringToFront sobre FP.']
  ],
  implementacao: ['A constante cFP identifica FPrincipal. A abertura do pedido usa Emisso1Click.', 'FinalizarFormulario no núcleo de faturamento chama FocarModulo e TrazerParaFrente após liberar FormCadastro.'],
  dependencias: ['P39_TDD_CASOS_DE_TESTE fornece inicialização, configuração e carga dos registros.'],
  limites: ['FP deve ser obtida por AbrirTela antes das chamadas de foco.', 'O fonte incorporado do PR #20 é evidência documental, sem declaração de homologação no ERP.']
});
