export type TCategoria = 'estrutura' | 'documentos' | 'guias' | 'units';
export type TEstado = 'legado' | 'em-uso' | 'em-desenvolvimento' | 'validado-no-erp';
export type TBloco =
  | { tipo: 'paragrafo'; texto: string }
  | { tipo: 'lista'; itens: string[] }
  | { tipo: 'tabela'; colunas: string[]; linhas: string[][] }
  | { tipo: 'codigo'; codigo: string; linguagem?: string }
  | { tipo: 'aviso'; texto: string; severidade: 'info' | 'warning' | 'error' | 'success' }
  | { tipo: 'mermaid'; fonte: string; titulo: string };
export interface ISecao {
  id: string;
  titulo: string;
  nivel?: 2 | 3 | 4;
  blocos: TBloco[];
}
export interface ISimbolo {
  nome: string;
  tipo: 'estado' | 'metodo';
  secao?: string;
  aliases?: string[];
  assinatura?: string;
}
export interface IDocumento {
  slug: string;
  categoria: TCategoria;
  titulo: string;
  resumo: string;
  estado: TEstado;
  fontes: { caminho: string }[];
  secoes: ISecao[];
  unit?: string;
  aliases?: string[];
  simbolos?: ISimbolo[];
  oculto?: boolean;
  referenciaAnterior?: string;
  evidenciaValidacao?: { data: string; versaoERP: string; referencia: string };
  navegacao?: { grupo: 'casos'; subgrupo: 'legado' | 'irunner'; ordem?: number };
}
export interface IDadosUnit {
  nome: string;
  aliases?: string[];
  aliasesArtefatos?: Record<string, string[]>;
  resumo: string;
  fonte: string;
  responsabilidade: string;
  problema: string;
  estado?: TEstado;
  evidenciaValidacao?: IDocumento['evidenciaValidacao'];
  estados?: [string, string, string][];
  metodos?: [string, string, string][];
  implementacao?: string[];
  dependencias?: string[];
  limites?: string[];
}
export interface IGrupoNavegacao {
  id: string;
  titulo: string;
  icone?: string;
  documentos?: IDocumento[];
  grupos?: IGrupoNavegacao[];
}
export interface IReferenciaUnit { texto: string; unit?: boolean }
export interface IResultadoBusca { documento: IDocumento; score: number; simbolos: ISimbolo[] }
