# Guerra Civil — Guia de Leitura (Civil War: Reading Guide)

Fan page independente e educacional, sem vínculo oficial com a Marvel Comics. Feita com HTML, CSS e JavaScript puros.

## Como executar
Abra `index.html` no navegador (ou use a extensão Live Server do VS Code). Não precisa de servidor nem de instalação.

## Estrutura
- `index.html`: estrutura das seções
- `css/style.css`: visual (paleta em variáveis no topo)
- `js/editions.js`: dados das 141 edições
- `js/script.js`: lista, busca, filtros, paginação, progresso e menu
- `assets/images/`: imagens (`hero/`, `editions/`, `characters/`)
- `docs/lista-original.txt`: lista fornecida (fonte dos dados)
- `docs/como-adicionar-imagens.md`: passo a passo para as imagens
- `docs/notas-de-revisao.md`: inconsistências encontradas na lista

## Dados
- **79** entradas originais → **141** edições individuais após expandir os **25** intervalos.
- Ordem preservada exatamente. O campo `position` é a posição na leitura; `number` é o número impresso na edição.
- Descrições e observações estão vazias, para preenchimento futuro. Nenhuma data, autor ou sinopse foi inventada.
- A ordem é a lista fornecida, sem verificação bibliográfica oficial.

## Funcionalidades
Busca por série/número, filtro (todas, não lidas, concluídas), paginação de 24 itens, progresso salvo no `localStorage`, três modalidades de leitura, placeholders de imagem e menu mobile.
O progresso é calculado sobre a modalidade escolhida (no guia completo, sobre as 141 edições), ignorando busca e filtros.

## Modalidades
- Essencial: `Civil War` (5 edições, #3 a #7, pois #1 e #2 não estão na lista).
- Recomendada: seleção provisória de 30 edições (títulos "Civil War").
- Completa: 141 edições.
