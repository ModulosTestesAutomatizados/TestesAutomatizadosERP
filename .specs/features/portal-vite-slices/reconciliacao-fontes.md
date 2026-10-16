# Reconciliação dos fontes fornecidos

O usuário atualizou docs/assets e confirmou estes arquivos como a versão mais recente. A documentação usa esta árvore, sem copiar arquivos de outra worktree. Os Pascal são registrados sem alterações do agente. O manifesto local de preservação está em Documentacoes/tools/vite-migration/fontes-atuais.json (ignorado).

## Alterações posteriores ao pacote

- RegistrarCasoTeste tem seis argumentos e fonte JSON única. O corpo atual recompõe camposDisponiveis e resultadoEsperado como propriedades nomeadas na raiz de CASO_TESTE_CT e guarda wrappers nomeados nas colunas dedicadas. O pacote anterior descrevia removê-las do payload e gravar somente objetos internos; essa descrição foi substituída pelo fonte novo fornecido pelo usuário.
- O comparador aceita o wrapper resultadoEsperado dos cadastros novos e o formato histórico com as seções erro/valor/tempo diretamente na raiz. Não criar wrapper duplo.
- O validador atual é docs/assets/emDesenvolvimento/P39_TDD_RUN_VALIDAR_RESULTADO.pas. O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda não corresponde ao nome de um arquivo local; permanece identificado como referência não resolvida no AST, sem modificar o código TDD ou alegar cadastro remoto.
- A descrição do registro financeiro em RegistrosCasosTestes agora é TDD_FIN_FINANCEIRO, assim como o cenário; o pacote anterior citava TDD_FINANCEIRO como chave de cadastro.
- Os mapeamentos usam novamente MAPEAR_COMPONENTES no sentido do código e o nome de arquivo contém MAPEAMENTO_COMPONENTES (nos arquivos: P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO/RECEBIMENTO). Títulos e menu usam os nomes reais completos, sem abreviação.
- P39_TDD_PARAMETRO é o arquivo local atual, substituindo o plural da documentação anterior. RUN_MODULO assume apenas telas/foco; SetModulo e seu estado pertencem a CASOS_DE_TESTE.
- TDD_RUN_LOGS declara RegistrarLog(pLog :string): sempre acumula pLog + #13 em FLogsCasoTeste; FModoDebug controla somente MostrarLogTexto. Chamadas a RegistrarLogEmModoDebug nos demais fontes são divergências de API ainda pendentes no Pascal.
- O cabeçalho do molde ainda menciona ASSERTS reservado, mas o corpo chama CompararResultadoEsperado e AssertsOk; a documentação descreve o corpo executável.

## Limites preservados

FLogsCasoTeste é liberado sem nil ao encerrar o lote. Data/RecNo e efeitos nativos de captura precisam de evidência no ERP. O lote não garante restauração automática de parâmetros, retry ou transação única para pai/filhos. Aliases documentais não comprovam nomes instalados. Nenhum gate local equivale a homologação.

## Novos moldes

O diretório físico fornecido é docs/assets/snippets (com dois p). Main e os três JSONs padrões serão expostos como fontes copiáveis; os três JSONs padrões receberão exceções específicas no gitignore por serem moldes compartilhados. JSONs de massa pessoais permanecem ignorados. Nenhum desses exemplos será executado pelo frontend.


Atualização observada durante a implementação: TDD_RUN_LOGS passou a RegistrarLog com acumulação incondicional e exibição condicionada a FModoDebug. Páginas/assinaturas e hashes foram atualizados após leitura do novo corpo. Chamadas antigas em outros Pascal são relatadas como divergência de API, sem reescrever os fontes.
