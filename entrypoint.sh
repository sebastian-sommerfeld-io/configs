#!/bin/bash
# @file entrypoint.sh
# @brief Entrypoint for Github Action.
#
# @description Entrypoint for Github Action. This script generated docs for all bash scripts of
# the respective repository and organizes them inside an Antora module.
#
# IMPORTANT: Do not run this script directly. This script is intended to run as part of a Github
# Actions job.
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


ANTORA_YML="docs/antora.yml"
export ANTORA_MODULE_NAME="auto-generated-bash-docs"
export ANTORA_MODULE="docs/modules/$ANTORA_MODULE_NAME"




# @description Generate a dedicated documentation file for a given script and save file inside the 
# Antora module.
#
# @example
#    echo "test: $(generateDocs path/to/some/script.sh)"
#
# @arg $1 String Path to bash script (mandatory)
#
# @exitcode 8 If path to bash script is missing
function generateDocs() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR Param missing: Path to bash script"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  SH_FILE="${1#"$(pwd)/"}" # clear path from $1
  SH_FILENAME="${SH_FILE##*/}"

  old=".sh"
  new="-sh"
  DOCS_FILE_PATTERN="${SH_FILE/"$old"/"$new"}" # change .sh to -sh

  ADOC_FILE="$DOCS_FILE_PATTERN.adoc"

  DOCS_PATH=${DOCS_FILE_PATTERN%/*}
  if [ "$DOCS_PATH" = "$DOCS_FILE_PATTERN" ]; then
    DOCS_PATH=""
  fi

  # TODO generate docs from *.sh
  # TODO convert md to adoc
  # TODO write adoc files

  echo -e "$LOG_INFO Create $ANTORA_MODULE/pages/$ADOC_FILE"
  mkdir -p "$ANTORA_MODULE/pages/$DOCS_PATH"

  echo "= $SH_FILENAME" > "$ANTORA_MODULE/pages/$ADOC_FILE"
  (
    echo
    echo "// +-----------------------------------------------+"
    echo "// |                                               |"
    echo "// |    DO NOT EDIT HERE !!!!!                     |"
    echo "// |                                               |"
    echo "// |    File is auto-generated by pipline.         |"
    echo "// |    Contents are based on bash script docs.    |"
    echo "// |                                               |"
    echo "// +-----------------------------------------------+"
    echo
  ) >> "$ANTORA_MODULE/pages/$ADOC_FILE"
}
export -f generateDocs


# @description Generate nav.adoc file for Antora module.
#
# @example
#    echo "test: $(generateNav)"
function generateNav() {
  echo -e "$LOG_INFO Generate nav.adoc partial for bash scripts"
  touch "$ANTORA_MODULE/partials/nav.adoc"
  
  (
    cd "$ANTORA_MODULE/pages" || exit

    find "." -name '*-sh.adoc' -print0 | while IFS= read -r -d '' file
    do
      file="${file#./}"
      echo "* xref:$ANTORA_MODULE_NAME:${file}[${file}]" >> "../partials/nav.adoc"
    done
  )

  echo -e "$LOG_INFO Generate nav.adoc"
  echo "* xref:$ANTORA_MODULE_NAME:index.adoc[]" > "$ANTORA_MODULE/nav.adoc"
  # echo "include::$ANTORA_MODULE_NAME:partial\$bash-script-docs/nav.adoc[]" >> "$ANTORA_MODULE/nav.adoc"

  echo -e "$LOG_INFO Generate index.adoc"
  cp assets/auto-generated-bash-docs/index-template.adoc "$ANTORA_MODULE/pages/index.adoc"
  # echo "= Bash Script Docs" > "$ANTORA_MODULE/pages/index.adoc"
  (
    echo
    echo "include::$ANTORA_MODULE_NAME:partial\$/nav.adoc[]"
  ) >> "$ANTORA_MODULE/pages/index.adoc"
}


echo -e "$LOG_INFO Initialize directory structure"
rm -rf "$ANTORA_MODULE"
mkdir "$ANTORA_MODULE"
mkdir "$ANTORA_MODULE/pages"
mkdir "$ANTORA_MODULE/partials"


echo -e "$LOG_INFO Find all *.sh files and generate docs"
find "$(pwd)" -type f -name "*.sh" -exec bash -c 'generateDocs "$0"' {} \;

echo -e "$LOG_INFO Create nav.adoc"
generateNav

echo -e "$LOG_INFO Add module to antora.yml"
line="  - modules/$ANTORA_MODULE_NAME/nav.adoc"
grep -qxF "$line" "$ANTORA_YML" || echo "$line" >> "$ANTORA_YML"
