# STATE

## Decisions

Nenhuma decisao AD de projeto foi registrada como aprovada nesta entrega. As restricoes confirmadas pelo usuario e as propostas locais estao em `.specs/features/tdd-irunner-lote-json/context.md` e `spec.md`. A especificacao historica do MVP permanece preservada e nao comprova a implementacao nos arquivos atuais em Runner.

## Handoff

- **Feature:** .specs/features/tdd-irunner-lote-json/
- **Phase / Task:** Etapa incremental 12: Finished sem logs de persistência; Clear por Run verificado.
- **Completed:** Emissores de logs de persistência removidos de Finished; SQL/captura preservados. Clear já existe no finally externo de Run, após sucesso/exception. Campo/parametro/record renomeados; Finished captura Text antes do INSERT; Base sem cópia redundante; migration em sql/temp-local e MER indicando alteração prevista. Limpeza de ExecutarLote sequencial; primeira falha interrompe chamadas seguintes e sobe com contexto. Run preservado. Piloto com seis procedures, seleção incorporada ao pagamento e _IncluirBordero por tipo; resultados/setter retirados e teardown no final. Instruções com 116 caracteres e quebras alinhadas. Oito fontes do fluxo ajustados localmente. Wrappers e fallbacks de configuração do piloto removidos por autorização; quatro campos validados antes das gravações. Três opcionais confirmados e preservados. Log global por caso integrado e instruções padronizadas com exibição condicionada. Quatro procedures de exibição de debug removidas após busca sem chamadores nos arquivos Pascal locais. Main do molde e duas linhas iniciais preservados. SQL, ordem financeira e regras de Started permanecem.
- **In-progress:** Gates funcionais do plano amplo pendentes. Nenhum requisito Verified por auditoria estrutural.
- **Next step:** Sem UPDATE de logs: Finished não registra mensagens de persistência conforme decisão do usuário; migration requer execução/validação autorizada antes de usar o novo nome no ERP. Revisão do usuário e autorização para validação no ERP; demais pendências de runtime/restauração continuam registradas. Não repetir testes financeiros automaticamente.
- **Blockers:** Sem execução nativa realizada; Currency/JSON, visibilidade compartilhada e restauração de parâmetros ainda exigem provas.
- **Uncommitted files:** Oito fontes locais, registros TLC e mapa de uses. Configuração, Documentacoes, HTMLs e exemplo externos preservados.
- **Branch:** master.
