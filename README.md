# My custom Debian

Esse script tem como objetivo automatizar a instalação customizada da distribuição **Debian**, previamente configurada.

Para a correta execução dessa ferramenta, é necessário realizar uma instalação limpa do Debian. 

---

# Instalação limpa

Essa seção contém informações e procedimentos para realizar uma instalação limpa do Debian.

Primeiramente é necessário realizar o download do **Debian stable** através do site oficial do projeto, [clicando aqui]().

Após realizar o download do sistema, instale-o através do modo expert.

---

# Instalação

Após realizada a instalação limpa da distro, basta executar o comando abaixo para realizar a configuração automática do sistema:

```bash
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/jonasGN/my-linux/main/install.sh)"
```

---

# Customização

É possível customizar algumas configurações para realizar uma instalação alternativa. Para isso, é necessário criar um arquivo na raíz do projeto chamado **custom.conf**.

## Pacotes

Para acrescentar pacotes a instalação, basta criar uma das ou ambas as entradas abaixo, contendo o nome do pacote da seguinte forma:

```bash
# entrada para INSTALAR pacotes
CUSTOM_PACKAGES=(
    "nome-do-pacote"
)

# entrada para DESINSTALAR pacotes
CUSTOM_UNINSTALL_PACKAGES=(
    "nome-do-pacote"
)
```
