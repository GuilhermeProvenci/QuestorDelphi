# Desafio Técnico Questor - Sistema de Pedidos

Sistema para gerenciamento de pedidos em Delphi, com dados em memória e geração de SQL.

## Características Principais

- **Arquitetura em Camadas**: Separação entre domínio, infraestrutura e apresentação (domain, infrastructure, presentation)
- **Design Patterns**: Repository Pattern (Singleton), Builder Pattern (SQL)
- **Geração de SQL**: Suporte a Firebird, Oracle e PostgreSQL com filtros dinâmicos
- **Testes Unitários**: Cobertura de regras de domínio e geração de SQL
- **Interface MDI**: Múltiplas janelas para gerenciamento simultâneo
- **Exportação**: CSV e JSON

## Estrutura do Projeto

```
/src
  /domain
    nCliente_U.pas
    nProduto_U.pas
    nPedido_U.pas
    nPedidoItem_U.pas

  /infrastructure
    nRepositorioMem_U.pas
    nSqlBuilder_U.pas
    nSqlDialeto_U.pas
    nExportador_U.pas

  /presentation
    nFrmMain_U.pas
    nFrmClientes_U.pas
    nFrmProdutos_U.pas
    nFrmPedidos_U.pas
    nFrmSqlPreview_U.pas

  /tests
    nDomainTests_U.pas
    nSqlBuilderTests_U.pas
```

## Padrões de Nomenclatura Implementados conforme a documentação

### Variáveis

- **Globais**: Prefixo `F` (ex: `FCodigoPedido`)
- **Locais**: Prefixo `A` (ex: `ATotal`)
- **Parâmetros**: Prefixo `_A` (ex: `_AValor`)

### Convenções

- **Classes**: `TnNomeClasse` (ex: `TnPedido`)
- **Units**: Singular com padrão `nNome_U.pas` (`nPedido_U.pas`)
- **Métodos/Propriedades**: UpperCamelCase (`CalcularTotal`)
- **Constantes**: UPPER_SNAKE_CASE (`SQL_BASE`)

## Funcionalidades Implementadas

### Cadastros

- Clientes (Código, Nome, CPF/CNPJ, Ativo)
- Produtos (Código, Descrição, Preço Unitário, Ativo)
- Pedidos com itens (Número, Cliente, Data, Status)

### Regras de Negócio

- Pedido não pode ser salvo sem itens
- Item deve ter Quantidade > 0 e Preço Unitário > 0
- Cálculo automático do valor total do pedido
- Bloqueio de edição após faturamento
- Status do pedido: Aberto, Faturado, Cancelado

### Filtros de Pedidos

- Período (Data Início e Fim)
- Cliente específico
- Status do pedido
- Texto livre (número do pedido ou nome do cliente)

## Design Patterns Utilizados

### 1. Repository Pattern (Singleton)

**Classe**: `TnRepositorioMem`

Acesso aos dados em memória com uma única instância:

```pascal
ARepositorio := TnRepositorioMem.Instancia;
APedidos := ARepositorio.ListarPedidos;
```

**Motivo**:

- Centralização do acesso a dados
- Facilita futura troca para banco de dados real
- Único ponto de controle das entidades

### 2. Builder Pattern

**Classe**: `TnSqlBuilder`

Queries SQL de forma incremental:

```pascal
ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);
```

**Motivo**:

- Montagem condicional das cláusulas WHERE
- Código limpo
- Parâmetros gerenciados automaticamente

### 3. Strategy Pattern (Implícito)

**Classe**: `TnSqlDialeto`

Permite trocar o dialeto SQL sem alterar a lógica:

```pascal
ADialeto := TnSqlDialeto.Create(tdFirebird);
ABuilder := TnSqlBuilder.Create(ADialeto);
```

**Motivo**:

- Suporte a múltiplos bancos de dados
- Extensão para novos dialetos

## Testes Unitários

### Framework

Usando **DUnitX** para testes automatizados.

#### Testes de Domínio (`nDomainTests_U.pas`)

- `TestNaoPodeSalvarPedidoSemItens` - Valida impedimento de pedido vazio
- `TestCalculoValorTotal` - Verifica soma correta dos itens
- `TestNaoPodeEditarPedidoFaturado` - Garante bloqueio após faturamento
- `TestPodeFaturarPedidoAberto` - Valida transição de status
- `TestNaoPodeFaturarPedidoSemItens` - Impede faturar pedido inválido
- `TestItemDeveQtdeMaiorZero` - Valida quantidade do item

#### Testes de SQL (`nSqlBuilderTests_U.pas`)

- `TestSelectSemFiltros` - SQL básico sem WHERE
- `TestSelectComFiltroData` - Filtro por período
- `TestSelectComFiltroCliente` - Filtro por cliente
- `TestSelectComFiltroStatus` - Filtro por status
- `TestSelectComTextoLivre` - Busca em múltiplos campos
- `TestSelectComTodosFiltros` - Combinação de filtros
- `TestOrdenacaoPorData` - ORDER BY data
- `TestOrdenacaoPorNumero` - ORDER BY número
- `TestParametrosSaoGerados` - Validação de parâmetros

## Como Executar

### Requisitos

- Delphi 10.3 Rio ou superior
- Componentes VCL padrão

### Compilação

1. Abrir o projeto `.dpr` no Delphi
2. Build → Compile
3. Run (F9)

### Primeiro Uso

Deverá ser realizado os cadastros no Menu -> Cadastros ->

- Clientes
- Produtos
- Pedidos

### Por que Singleton no Repositório?

Garante que todas as partes da aplicação trabalhem com a mesma instância de dados em memória.

### Por que Builder para SQL?

A construção de SQL dinâmico é complexa e pode gerar erros. O Builder Pattern:

- Encapsula a lógica de montagem
- Gerencia parâmetros automaticamente
- Facilita testes unitários
- Evita SQL Injection

### Por que Validação em Dois Níveis?

1. **Entidades**: Validam seus próprios dados (responsabilidade única)
2. **Repositório**: Valida antes de salvar (camada adicional de segurança)

### O que Foi Priorizado

1. **Organização do código**
2. **Padrões de nomenclatura**
3. **Regras de negócio**
4. **Geração de SQL**
5. **Testes unitários**

## Autor

Desenvolvido por Guilherme Provenci de Lima
