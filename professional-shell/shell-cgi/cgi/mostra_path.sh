#!/bin/bash
# avisa o navegador que eh um html texto
echo Content-type: text/html ; echo
PATH=$PATH:/dir_falso

# tag ul indica uma lista
echo "<ul>"
# muda o caractere de separacao do for
# enves de processar a cada espaco eh usado :
IFS=:
for diretorio in $PATH
do
    if test -d $diretorio
    then
        extra="existe"
    else
        extra="nao existe"
    fi
    # cada interacao mostra um elemento na lista
    echo "<li>$diretorio ($extra)</li>"
done
# encerra a lista
echo "</ul>"
