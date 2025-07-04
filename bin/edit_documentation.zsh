#! /bin/zsh
# edit_documentation.zsh
#
# Add/Change subjects in the documentation
#
# Contributers:
#    Edwin Pijper - @belastingdienst.nl

#--------------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------------
CUR_DIR=$(pwd)
PROGRAM=$0
PROGRAM_BIN_DIR=$(dirname "${PROGRAM}")
cd "${PROGRAM_BIN_DIR}"
PROGRAM_BIN_DIR=$(pwd)
cd ..
PROGRAM_DIR=$(pwd)
SCRIPTS_DIR="${PROGRAM_DIR}/scripts"
ETC_DIR="${PROGRAM_DIR}/etc"
DATA_DIR="${PROGRAM_DIR}/data"
cd ${CUR_DIR}
DOC="${PROGRAM_DIR}/readme.md"

#--------------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------------
[[ ! -s "${PROGRAM_DIR}/readme.md" ]] && \
  {
    echo "ERROR: documentatie (readme.md) niet gevonden"
    exit 1
  }

[[ ! -d "${SCRIPTS_DIR}" ]] && \
  {
    echo "ERROR: script directory (scripts) niet gevonden"
    exit 1
  }

for SCRIPTNAME in $(ls ${SCRIPTS_DIR} | grep -v ".bak$";echo BAU_Settings description uninstaller) 
do
  case "${SCRIPTNAME}" in
    preuninstall)
      DOC_LABEL=PreUninstall_script
      FILE_PATH="${SCRIPTS_DIR}/${SCRIPTNAME}"
      ;;
    postuninstall)
      DOC_LABEL=PostUninstall_script
      FILE_PATH="${SCRIPTS_DIR}/${SCRIPTNAME}"
      ;;
    preinstall|postinstall)
      DOC_LABEL=$(echo ${(C)SCRIPTNAME})
      FILE_PATH="${SCRIPTS_DIR}/${SCRIPTNAME}"
      ;;
    BAU_Settings)
      DOC_LABEL="macOS_DBx_BAU_settings"
      FILE_PATH="${ETC_DIR}/${SCRIPTNAME}"
      ;;
    description)
      DOC_LABEL="Description"
      FILE_PATH="${DATA_DIR}/${SCRIPTNAME}"
      ;;
    uninstaller)
      DOC_LABEL="Uninstaller_info"
      FILE_PATH="${DATA_DIR}/uninstaller.log"
      ;;
    *)
      echo WARN:Verkeerde script \""${SCRIPTNAME}"\". Deze wordt niet meegenomen
      continue
      ;;
  esac

  if [[ -s "${FILE_PATH}" ]]
  then
    cat "${DOC}" | awk -v LABEL=${DOC_LABEL} '
      BEGIN { F = 0 }
      F != 2 { print $0 }
      $1 ~ LABEL { F = 1}
      F == 1 && $1 ~ /^```bash$/ { F = 2}' > new_doc$$
    cat "${FILE_PATH}" >> new_doc$$ 2>&1

    cat "${DOC}" | awk -v LABEL="${DOC_LABEL}" '
      BEGIN { F = 0 }
      $1 ~ LABEL { F = 1}
      F == 1 && $1 ~ /^```$/ { F = 2}
      F == 2 { print $0 }' >> new_doc$$

    mv -f new_doc$$ "${DOC}"
  fi
done