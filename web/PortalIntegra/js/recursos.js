// Recursos externos gratuitos; os links abrem os sites oficiais.
const recursos = [
 {nome:'Khan Academy',descricao:'Aulas e exercícios gratuitos para reforçar conteúdos de diferentes disciplinas.',categoria:'estudos',icone:'📚',url:'https://pt.khanacademy.org/'},
 {nome:'Google Acadêmico',descricao:'Busque artigos, trabalhos científicos e outras publicações acadêmicas.',categoria:'pesquisa',icone:'🔎',url:'https://scholar.google.com.br/'},
 {nome:'SciELO',descricao:'Acesse uma biblioteca de periódicos e artigos científicos.',categoria:'pesquisa',icone:'📖',url:'https://www.scielo.br/'},
 {nome:'MDN Web Docs',descricao:'Consulte referências e guias de HTML, CSS e JavaScript.',categoria:'programacao',icone:'💻',url:'https://developer.mozilla.org/pt-BR/'},
 {nome:'freeCodeCamp',descricao:'Pratique programação com trilhas e exercícios interativos.',categoria:'programacao',icone:'⌨️',url:'https://www.freecodecamp.org/portuguese/'},
 {nome:'Google Agenda',descricao:'Organize compromissos, prazos e sessões de estudo.',categoria:'organizacao',icone:'📅',url:'https://calendar.google.com/'}
];
const categoriaRecurso=document.querySelector('#categoriaRecurso');
const buscaRecurso=document.querySelector('#buscaRecurso');
const listaRecursos=document.querySelector('#listaRecursos');
const resultadoRecursos=document.querySelector('#resultadoRecursos');
function renderizarRecursos(lista){
 listaRecursos.replaceChildren();
 if(lista.length===0){const aviso=document.createElement('p');aviso.className='resources-empty';aviso.textContent='Nenhum recurso encontrado. Tente outra categoria ou termo de busca.';listaRecursos.appendChild(aviso);return;}
 lista.forEach(recurso=>{
  const card=document.createElement('article');card.className='resource-card';
  const icone=document.createElement('span');icone.className='resource-icon';icone.textContent=recurso.icone;icone.setAttribute('aria-hidden','true');
  const categoria=document.createElement('span');categoria.className='resource-category';categoria.textContent=recurso.categoria;
  const titulo=document.createElement('h3');titulo.textContent=recurso.nome;
  const descricao=document.createElement('p');descricao.textContent=recurso.descricao;
  const link=document.createElement('a');link.href=recurso.url;link.target='_blank';link.rel='noopener noreferrer';link.className='resource-link';link.textContent='Acessar recurso ↗';link.setAttribute('aria-label',`Acessar ${recurso.nome} (abre em nova aba)`);
  card.append(icone,categoria,titulo,descricao,link);listaRecursos.appendChild(card);
 });
}
function atualizarRecursos(){
 const categoriaEscolhida=categoriaRecurso.value;
 const termo=buscaRecurso.value.trim().toLocaleLowerCase('pt-BR');
 const filtrados=recursos.filter(recurso=>(categoriaEscolhida==='todos'||recurso.categoria===categoriaEscolhida)&&(`${recurso.nome} ${recurso.descricao}`.toLocaleLowerCase('pt-BR').includes(termo)));
 renderizarRecursos(filtrados);
 resultadoRecursos.textContent=`${filtrados.length} recurso(s) encontrado(s).`;
}
categoriaRecurso.addEventListener('change',atualizarRecursos);
buscaRecurso.addEventListener('input',atualizarRecursos);
atualizarRecursos();
