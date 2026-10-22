// Validação de formato: não comprova a existência dos dados informados.
const formulario = document.querySelector('#formContato');
const email = document.querySelector('#email');
const telefone = document.querySelector('#telefone');
const erroEmail = document.querySelector('#erroEmail');
const erroTelefone = document.querySelector('#erroTelefone');
const mensagemFormulario = document.querySelector('#mensagemFormulario');

function validarEmail() {
    const valor = email.value.trim();
    const valido = /^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$/.test(valor);
    erroEmail.textContent = valido ? '' : 'Informe um e-mail válido (ex.: aluno@exemplo.com).';
    email.setAttribute('aria-invalid', String(!valido));
    return valido;
}

function validarTelefone() {
    const numeros = telefone.value.replace(/\D/g, '');
    const valido = /^[1-9][0-9][2-9][0-9]{7,8}$/.test(numeros);
    erroTelefone.textContent = valido ? '' : 'Informe um telefone com DDD e 10 ou 11 dígitos.';
    telefone.setAttribute('aria-invalid', String(!valido));
    return valido;
}

telefone.addEventListener('input', () => {
    const digitos = telefone.value.replace(/\D/g, '').slice(0, 11);
    if (digitos.length <= 2) telefone.value = digitos ? `(${digitos}` : '';
    else if (digitos.length <= 6) telefone.value = `(${digitos.slice(0,2)}) ${digitos.slice(2)}`;
    else {
        const tamanhoPrefixo = digitos.length > 10 ? 5 : 4;
        telefone.value = `(${digitos.slice(0,2)}) ${digitos.slice(2, 2+tamanhoPrefixo)}-${digitos.slice(2+tamanhoPrefixo)}`;
    }
    if (erroTelefone.textContent) validarTelefone();
});
email.addEventListener('blur', validarEmail);
telefone.addEventListener('blur', validarTelefone);

formulario.addEventListener('submit', (evento) => {
    evento.preventDefault();
    const emailValido = validarEmail();
    const telefoneValido = validarTelefone();
    const demaisValidos = Array.from(formulario.elements)
        .filter((campo) => campo !== email && campo !== telefone && typeof campo.checkValidity === 'function')
        .every((campo) => campo.checkValidity());
    if (!emailValido || !telefoneValido || !demaisValidos) {
        mensagemFormulario.textContent = 'Corrija os campos indicados antes de continuar.';
        mensagemFormulario.className = 'form-feedback error';
        if (!emailValido) email.focus();
        else if (!telefoneValido) telefone.focus();
        else formulario.reportValidity();
        return;
    }
    mensagemFormulario.textContent = 'Dados validados! Este formulário é demonstrativo e não envia mensagens.';
    mensagemFormulario.className = 'form-feedback success';
});
