// Aula 11: filtro interativo dos serviços já existentes no Portal.
const listaServicos = document.querySelector('#listaServicos');
const filtroCategoria = document.querySelector('#filtroCategoria');
const mensagemFiltro = document.querySelector('#mensagemFiltro');

// Mantém os cards originais, incluindo seus ícones, textos, links e estilos.
const servicos = Array.from(listaServicos.querySelectorAll('.service-card')).map((card) => ({
    nome: card.querySelector('h3').textContent.trim(),
    descricao: card.querySelector('.service-card-content > p').textContent.trim(),
    categoria: card.querySelector('.service-tag').textContent.trim().toLowerCase(),
    card
}));

console.table(servicos.map(({ nome, descricao, categoria }) => ({ nome, descricao, categoria })));

function renderizarServicos(lista) {
    listaServicos.replaceChildren();
    if (lista.length === 0) {
        const aviso = document.createElement('p');
        aviso.className = 'filter-empty';
        aviso.textContent = 'Nenhum serviço foi encontrado nesta categoria.';
        listaServicos.appendChild(aviso);
        return;
    }
    lista.forEach((servico) => listaServicos.appendChild(servico.card));
}

filtroCategoria.addEventListener('change', () => {
    const categoriaEscolhida = filtroCategoria.value;
    const filtrados = categoriaEscolhida === 'todos'
        ? servicos
        : servicos.filter((servico) => servico.categoria === categoriaEscolhida);
    renderizarServicos(filtrados);
    mensagemFiltro.textContent = categoriaEscolhida === 'todos'
        ? `Mostrando todos os ${servicos.length} serviços.`
        : `${filtrados.length} serviço(s) encontrado(s).`;
});

renderizarServicos(servicos);
mensagemFiltro.textContent = `Mostrando todos os ${servicos.length} serviços.`;
