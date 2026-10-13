# Contexto: portal de documentação TDD

Data: 2026-10-06. Método solicitado: TLC Spec Driven. Complexidade: Large, por envolver conteúdo multicomponente, navegação, catálogo, diagramas, migração editorial e publicação estática.

## Histórico de autorização e etapa atual

O pedido inicial autorizou analisar o diff e materiais existentes e produzir a especificação. Em 2026-10-06 o usuário respondeu “Pode seguir!” após receber a spec. O aceite permite avançar o planejamento técnico. O design e a pesquisa CDN/Pages foram produzidos; o fluxo TLC prevê revisão do design antes de Tasks. A issue #22 permanece aberta: o planejamento não entrega o portal.

## Instruções confirmadas pelo usuário

- Considerar documentação como parte predominante do material novo do Git.
- Analisar a refatoração em `docs/assets/emDesenvolvimento/Runner/`, ainda incompleta.
- Manter o body da issue #22 no contexto. O texto integral está em `issue-22.md`, capturado via GitHub.
- Estruturar as documentações usando Vue e PrimeVue via CDN.
- Construir componentes reutilizáveis.
- Manter um snippet para registrar a documentação de novos casos de teste.
- Disponibilizar o resultado no GitHub Pages.
- Colocar `index.html` na raiz da aplicação, servindo apenas como entrada.
- Usar Vue Router para roteamento.

## Requisitos vindos da issue

Documentação estática dos testes TDD do ERP: estrutura adotada, implementação, estratégias/problemas/justificativas, responsabilidade de cada unit, diagramas genéricos e específicos e exemplos de novos casos. Catálogo deve incluir Documento Fatura e Financeiro. A documentação acompanha entregas de novos casos da próxima milestone. Épica #10; milestone informada no body: Estrutura Adotada. Esses metadados continuam no GitHub.

## Defaults da especificação aceita

| Área | Default para a especificação | Motivo |
| --- | --- | --- |
| Navegação | Vue Router com hash | Recarregar links internos no Pages sem regras de servidor |
| Conteúdo | Catálogo local em módulos JavaScript, blocos tipados, componentes genéricos | Novo documento não duplica layout e `.json` é ignorado atualmente |
| Runner principal | Refatoração, identificada como Em desenvolvimento; legado separado | Pedido destaca o fluxo novo, mas não afirma conclusão |
| Catálogo inicial | Documento Fatura, três cenários de Pedido e Financeiro | Conteúdo já existente e entrega explícita da issue |
| Publicação | Workflow de Pages com artefato selecionado do portal | Repositório contém fontes, configs e especificações que não compõem o site |
| Autoria | Registro declarativo em arquivo de conteúdo e uma inclusão no catálogo | Atende ao snippet sem criar CMS ou gravar banco |
| Evolução | Sem busca global, editor, autenticação, API de dados ou execução ERP | Escopo estático da issue |
| Conteúdo técnico | Citações de fonte e estado: observado localmente, planejado, validado no ERP | Evita converter documentação antiga em garantia funcional |
| Origem dos casos | Conferir fonte correspondente antes de publicar receitas de Faturamento/Financeiro | Dez arquivos de Faturamento e sete de Financeiro repetem conteúdo sob nomes diferentes |
| Links antigos | Redirecionamentos estáticos nos cinco index existentes após migrar conteúdo | Preserva bookmarks sem repetir a interface |
| Dependências | URLs CDN com versões exatas compatíveis, fixadas e comprovadas no design | Documentação atual inclui exemplos de versões diferentes |

As escolhas acima foram submetidas como defaults na especificação e receberam aceite geral para prosseguir. Isso não representa aprovação de artefatos posteriores ainda não apresentados. Os detalhes técnicos e versões fixadas estão em `design.md` para revisão.

## Pesquisa posterior ao aceite

Vue 3.5.43, Router 4.6.4, PrimeVue 4.5.5, Aura 1.2.5 e Mermaid 11.17.2 passaram em um probe nominal Chromium, na raiz HTTP e no prefixo do projeto. A combinação ainda precisa dos testes do portal completo. O repositório é público, default branch master, Pages não habilitado. A credencial consultada não possui admin/maintain. Evidência completa em `evidencias/pesquisa-cdn-pages.md`.

Foi proposta por pergunta assíncrona a cobertura Node/catálogo e Playwright/navegador. Sem resposta registrada até o fechamento do design; permanece recomendação para a próxima etapa.

## Referências locais e fontes de verdade

1. `issue-22.md`: pedido original integral; requisitos posteriores do usuário prevalecem quando acrescentam restrições.
2. `analise.md`: inventário, conclusões e evidências do snapshot.
3. Fontes locais em Runner e piloto: comportamento observado na implementação local.
4. `Documentacoes/` e mapas: material editorial a revisar, não contrato único do runtime.
5. `.specs/features/tdd-irunner-lote-json/spec.md` e `.specs/STATE.md`: intenções e pendências anteriores, sem importar o status de implementação como comprovação.

## Ideias adiadas

Busca textual global, filtros avançados, edição pelo navegador, conexão com TekStore/bancos, execução de testes pelo site, conversão para SFC/Vite e homologação da refatoração. Não são necessárias para entregar a documentação estática especificada.
