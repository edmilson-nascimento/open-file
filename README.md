# Importação de arquivo #

[![N|Solid](https://wiki.scn.sap.com/wiki/download/attachments/1710/ABAP%20Development.png?version=1&modificationDate=1446673897000&api=v2)](https://www.sap.com/brazil/developer.html)

Esta opção trata da necessidade a acessar um arquivo no servidor. Infelizmente quando iniciei o desenvolvimento, não souberam me falar o sistema operacional do servidor e qual o formato de arquivos. Notei que tenho diferentes parâmetros para isso em ABAP. Logo foram feitos testes e no caso, foi definido o modelo/padrão certo para este cliente.

~~Quando Deus der coragem~~ Futuramente eu vou melhorar o codigo e mudar com uma boa documentação.

## Necessidade ##
Importar um arquivo do servidor para que ele seja anexado em um e-mail.

## Tecnologia adotada ##
ABAP usando classe BDC para envio de e-mail.

## Solução ##
Importar o arquivo, via `open data set`, converter em hexadecial e anexo no e-mail.
