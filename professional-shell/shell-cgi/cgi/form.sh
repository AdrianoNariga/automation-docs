#!/bin/bash
echo Content-type: text/html ; echo

echo "<h1>Os dados enviados foram:</h1>"
echo "<pre>"

read tripa
# troca &+ por quebra de linha
echo "$tripa" | tr '&+' '\n '
