# Ferramentas de Localização de Defeitos Baseadas em Espectro em Ambiente de Integração Contínua
Trabalho a ser submetido ao XXXVII Simpósio Brasileiro de Engenharia de Software, na trilha de pesquisa.

## Objetivo
Este trabalho tem como objetivo avaliar os principais fatores que possam influenciar o uso de ferramentas de localização de defeitos baseadas em espectro em ambiente de integração contínua. No experimento foram utilizadas as ferramentas: [Flacoco](https://github.com/SpoonLabs/flacoco), [GZoltar](https://github.com/GZoltar/gzoltar), [Jaguar](https://github.com/saeg/jaguar) and [Jaguar2](https://github.com/saeg/jaguar2), sobre os projetos: "Codec", "Collections", "Compress", "Csv", "Gson", "JacksonDatabind", "JacksonXml", "Jsoup", "Lang", "Math" e "Time" da coleção de projetos com defeitos reproduzíveis [Defects4J](https://github.com/rjust/defects4j).

## Laboratório - Compilando e executando o contêiner localmente
Passo 1: Clone este respositório
```
git clone ANONIMIZADO
```

Passo 2: Entre no diretório
```
cd labsfl20221114
```

Passo 3: Construa a imagem
```
docker build -t labsfl20221114:latest . 
```

Passo 4: Execute o contêiner com um volume montado para exportação dos resultados. 
Altere `/tmp/labsfl20221114` para seu local de resultados.
O parâmetro `REPEAT` configura a variável de ambiente para definir a quantidade de repetições que será executada para cada projeto.
```
docker run --name labsfl20221114 --env REPEAT=10 --rm -v /tmp/labsfl20221114:/labsfl20221114/test labsfl20221114:latest
```

### Executando o contêiner no Azure Container Instance (Alternativa)
O arquivo [azure-container-instance.sh](labsfl20221114/azure-container-instance.sh) contém script com criação de recursos para execução de contêiner no **Azure Container Instance**, este script utiliza [Azure CLI](https://learn.microsoft.com/pt-br/cli/azure/), que pode ser executado no Cloud Shell do Azure Portal ou através do [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) para executá-lo localmente. Obs.: É necessário a alteração dos cinco primeiros parâmetros do arquivo [azure-container-instance.sh](labsfl20221114/azure-container-instance.sh). Se você ainda não tiver logado no Microsoft Azure através do Azure CLI, é necessário executar o comando `az login` para autenticação.

O script irá criar os um `Resource Group`, `Storage Account` e `Azure Container Instance`, em sua conta do Azure.

Obs.: Por momento, o nome da imagem no DockerHub foi anonimizada no script, para que não seja possível a identificação, portanto é necessário a publicação da imagem do contêiner antes da execução no Azure Container Instance.
```
./azure-container-instance.sh
```

## DotNet SFL Tool - Ferramenta de normalização de dados
Esta ferramenta foi criada com o objetivo de normalizar os dados coletados pelas ferramentas de SBFL deste experimento. Ela está sendo contruída na criação do contêiner e utilizada durante sua execução. Seu código fonte está disponível no diretório [dotnet-sfl-tool](dotnet-sfl-tool).

## Script de geração dos gráficos em R
Pacote de script em R para geração dos gráficos utilizados no trabalho. Seu código fonte está disponível no diretório [r-script-charts](r-script-charts).