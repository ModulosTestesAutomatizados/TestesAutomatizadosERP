// Executor restrito de métodos extraídos. Não compila Pascal nem substitui o ERP.
export function tokens(s) {
  const out=[];
  while(s.length){
    const ignored=s.match(/^(?:\s+|\/\/[^\n\r]*|\{[^}]*\}|\(\*[\s\S]*?\*\))/);if(ignored){s=s.slice(ignored[0].length);continue;}
    const m=s.match(/^(?:'((?:[^']|'')*)'|#(\d+)|(\d+(?:\.\d+)?)|([A-Za-z_]\w*)|(:=|<>|<=|>=|.))/s);if(!m)throw Error(s);
    out.push(m[1]!==undefined?{v:m[1].replaceAll("''","'"),str:true}:m[2]?{v:String.fromCharCode(+m[2]),str:true}:{v:m[3]??m[4]??m[5]});s=s.slice(m[0].length);
  }return out;
}
class Parser {
  constructor(ts){this.ts=ts;this.i=0;}
  peek(){return this.ts[this.i]?.v.toLowerCase();}
  take(w){const t=this.ts[this.i++];if(!t||w&&t.v.toLowerCase()!==w)throw Error('Esperado '+w+', obtido '+t?.v);return t;}
  list(stops){let s='';while(this.i<this.ts.length&&!stops.includes(this.peek())){s+=this.statement()+'\n';if(this.peek()===';')this.take();}return s;}
  statement(){
    const k=this.peek();
    if(k==='begin'){this.take();const s=this.list(['end']);this.take('end');return '{'+s+'}';}
    if(k==='if'){this.take();const c=this.expr();this.take('then');const s=this.statement();if(this.peek()==='else'){this.take();return 'if('+c+'){'+s+'}else{'+this.statement()+'}';}return 'if('+c+'){'+s+'}';}
    if(k==='while'){this.take();const c=this.expr();this.take('do');return 'while('+c+'){'+this.statement()+'}';}
    if(k==='for'){this.take();const n=this.take().v;this.take(':=');const a=this.expr();const down=this.take().v.toLowerCase()==='downto';const b=this.expr();this.take('do');return `for(${n}=${a};${n}${down?'>=':'<='}${b};${n}${down?'--':'++'}){${this.statement()}}`;}
    if(k==='try'){this.take();const b=this.list(['except','finally']);const mode=this.take().v.toLowerCase();if(mode==='finally'){const f=this.list(['end']);this.take('end');return 'try{'+b+'}finally{'+f+'}';}let n='Ex';if(this.peek()==='on'){this.take();n=this.take().v;this.take(':');this.take();this.take('do');}const e=this.list(['end']);this.take('end');return 'try{'+b+'}catch('+n+'){'+e+'}';}
    if(k==='case'){this.take();const c=this.expr();this.take('of');let s='';while(!['else','end'].includes(this.peek())){const v=this.expr();this.take(':');s+='case '+v+':'+this.statement()+';break;';if(this.peek()===';')this.take();}if(this.peek()==='else'){this.take();s+='default:'+this.list(['end']);}this.take('end');return 'switch('+c+'){'+s+'}';}
    if(k==='raise'){this.take();return 'throw '+(this.peek()===';'?'Ex':this.expr())+';';}
    if(k==='exit'){this.take();return 'return Result;';}
    if(k==='continue'||k==='break'){this.take();return k+';';}
    const left=this.expr();if(this.peek()===':='){this.take();return left+'='+this.expr()+';';}
    return left+(/\)$/.test(left)?';':'();');
  }
  expr(min=0){
    const t=this.take();let left;
    if(t.str)left=JSON.stringify(t.v);
    else if(t.v==='('){left='('+this.expr()+')';this.take(')');}
    else if(t.v==='['){const a=[];while(this.peek()!==']'){a.push(this.expr());if(this.peek()!==']')this.take(',');}this.take(']');left='['+a.join(',')+']';}
    else if(['not','-','+'].includes(t.v.toLowerCase()))left='('+(t.v.toLowerCase()==='not'?'!':t.v)+this.expr(7)+')';
    else left=({nil:'null',true:'true',false:'false'})[t.v.toLowerCase()]??t.v;
    while(this.i<this.ts.length){
      if(this.peek()==='.'){this.take();left+='.'+this.take().v;continue;}
      if(this.peek()==='('||this.peek()==='['){const bracket=this.take().v;const end=bracket==='('?')':']';const args=[];while(this.peek()!==end){args.push(this.expr());if(this.peek()!==end)this.take(',');}this.take(end);left+=bracket+args.join(',')+end;continue;}
      const op=this.peek(),p=({or:1,and:2,'=':3,'<>':3,'<':3,'>':3,'<=':3,'>=':3,'+':4,'-':4,'*':5,'/':5,div:5,mod:5})[op];if(p===undefined||p<min)break;
      this.take();const r=this.expr(p+1);left=op==='div'?`Math.trunc(${left}/${r})`:`(${left}${({or:'||',and:'&&','=':'===','<>':'!==',mod:'%'})[op]??op}${r})`;
    }return left;
  }
}
export function compile(source,name,api){
  const matches=[...source.matchAll(/^(procedure|function)\s+(\w+)\b/gmi)];const i=matches.findIndex(m=>m[2].toLowerCase()===name.toLowerCase());if(i<0)throw Error('Método ausente: '+name);
  const ts=tokens(source.slice(matches[i].index,matches[i+1]?.index??source.length));const begin=ts.findIndex(t=>t.v.toLowerCase()==='begin');const sig=ts.slice(0,begin);let cursor=2;const params=[];
  if(sig[cursor]?.v==='('){cursor++;while(sig[cursor]?.v!==')'){if(['var','const'].includes(sig[cursor]?.v.toLowerCase()))cursor++;while(sig[cursor]?.v!==':'){if(sig[cursor].v!==',')params.push(sig[cursor].v);cursor++;}cursor+=2;if(sig[cursor]?.v===';')cursor++;}}
  const vars=['Result'];const at=sig.findIndex(t=>t.v.toLowerCase()==='var');if(at>=0){cursor=at+1;while(cursor<sig.length){while(sig[cursor]?.v!==':'){if(sig[cursor].v!==',')vars.push(sig[cursor].v);cursor++;}cursor+=2;if(sig[cursor]?.v===';')cursor++;}}
  const body=new Parser(ts.slice(begin)).statement();return new Function('api',`with(api){return function(${params.join(',')}){let ${[...new Set(vars)].join(',')};${body};return Result;}}`)(api);
}
