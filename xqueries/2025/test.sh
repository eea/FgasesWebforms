#!/bin/sh

# ruta del ejecutable de BaseX
BASEX_PATH="C:\\Program Files (x86)\\BaseX\\bin\\basex.bat"

# rutas de los archivos de entrada y salida
SOURCE_XML="D:\\PROYECTOS\\FgasesWebformsGitHub\\xqueries\\2025\\Questionnaire_on_verification_reporting_pursuant_to_Article_26_7__and_26_8__of_the_F-gas_Regulation__Regulation__EU__2024573___1.xml"
XQUERY_FILE="D:\\PROYECTOS\\FgasesWebformsGitHub\\xqueries\\2025\\fgases-2025-verification.xquery"
OUTPUT_HTML="D:\\PROYECTOS\\FgasesWebformsGitHub\\xqueries\\2025\\out2.html"
ERROR_LOG="D:\\PROYECTOS\\FgasesWebformsGitHub\\xqueries\\2025\\error.log"
OUTPUT_LOG="D:\\PROYECTOS\\FgasesWebformsGitHub\\xqueries\\2025\\output.log"

#salida estándar a output.log y los errores a error.log

"$BASEX_PATH" -bsource_url="$SOURCE_XML" "$XQUERY_FILE" > "$OUTPUT_HTML" 2> "$ERROR_LOG"


