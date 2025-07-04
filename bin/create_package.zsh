#! /bin/zsh
# create_package.zsh 
#
# Create dummy package for apps installed with installomator
#
# Contributers:
#    Edwin Pijper - @belastingdienst.nl

#--------------------------------------------------------------------------------
# Global variables
#--------------------------------------------------------------------------------
BELASTINGDIENST_APP_VERSION=$(date +'%y.%m.%d')
CUR_DIR="$(pwd)"
PROGRAM=$0
PROGRAM_BIN_DIR="$(dirname "${PROGRAM}")"
cd "${PROGRAM_BIN_DIR}"
PROGRAM_BIN_DIR=$(pwd)
cd ..
PROGRAM_DIR=$(pwd)
cd
USER_DIR="$(pwd)"
cd ${CUR_DIR}

PACKAGE_PATH="${USER_DIR}/OneDrive - Belastingdienst/DBO_macOS_Packaging"
APP=$(ls ${PROGRAM_DIR}/munkipkg_project)

# set to 0 for production, 1 for debugging
# while debugging, items will be downloaded to the parent directory of this script
# debug mode 0, no debug logging is created
# debug mode 1, gives you some information about variables  
# debug mode 2, will show debug information using set -x
DEBUG=0

#--------------------------------------------------------------------------------
# Usage
# Prints the way you have to use the program
# Input:
# -
# Return:
# -
#--------------------------------------------------------------------------------
Usage()
{
    echo ""
    echo "Usage: ${PROGRAM} [-p <PACKAGE PATH>] [-d <0|1|2>]"
    echo "creates a munki package from the source path> into the package"
    echo "-d              0: no debug info, 1 show VATIABLES, 2 show set -x"
    echo "-p              <PACKAGE PATH> = location to store the package and information to use in WorkSpace One"
    exit 1
}


#--------------------------------------------------------------------------------
Display_info()
{
# Print the comming action 
# Input:
# $1: message
# $2: tabs before message
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x
  
  MSG=$1
  if [[ -n $2 ]]
  then
    for ((i=1;i<=$2;i++))
    {
      MSG="   ${MSG}"
    }
  fi
  printf "%-50s: " ${MSG}
}


#--------------------------------------------------------------------------------
Display_title()
{
# Print the title 
# Input:
# $1: message
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x
  
  MSG=$1
  printf "%s\n" "${MSG:u}"
  LENGTH_MSG=${#MSG}
  for ((i=1;i<=${LENGTH_MSG};i++))
  do  
    printf "-"
  done
  printf "\n"
}


#--------------------------------------------------------------------------------
Display_vars()
{
# Print key and value 
# Input:
# $1: key 
# $2: value
# Return:
# -
#--------------------------------------------------------------------------------
  KEY=$1
  VALUE=$2
  printf "%-25s: %s\n" ${KEY} ${VALUE}
}


#--------------------------------------------------------------------------------
Display_OK()
{
# Print OK 
# Input:
# - 
# Return:
# -
#--------------------------------------------------------------------------------
  print "[ OK ]"
}


#--------------------------------------------------------------------------------
Display_error()
{
# Print Error  
# Input:
# $1: error message
# $2: exit code 
# Return:
# exit code $2
#--------------------------------------------------------------------------------
  print "[ FAIL ]"
  print "\tError: $1"
  print "\tReturn code: $2"
  exit $2
}


#--------------------------------------------------------------------------------
Check_rc()
{
# Print OK when retrun code is "0" or when not "0" and error message  
# Input:
# $1: rc
# $2: comment when failed
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x

  
  if [[ $1 -eq 0 ]]
  then
    Display_OK
  else
    Display_error $2 $1
  fi
}


#--------------------------------------------------------------------------------
Check_used_tools()
{
# Check if munkipkg is installed
# Input:
# Arguments from the command
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x

  Display_info "munkipkg is installed"
  which munkipkg > /dev/null 2>&1
  Check_rc $? "Can't find munkipkg"
}


#--------------------------------------------------------------------------------
GetArgs()
{
# Set arguments used in the command
# Input:
# Arguments from the command
# Return:
# -
#--------------------------------------------------------------------------------
  while getopts "d:p:" VAR
  do
    case "${VAR}" in
        d)
          DEBUG="${OPTARG}"
          ((DEBUG == 0 || DEBUG == 1 || DEBUG == 2)) || Usage
          ;;
        p)
          PACKAGE_PATH="${OPTARG}"
          [[ ${PACKAGE_PATH[1,1]} = '-' ]] &&  PACKAGE_PATH=""
          ;;
        *)
          Usage
          ;;
      esac
  done

  [[ -d "${PACKAGE_PATH}" ]] || {
    echo "ERROR package path \"${PACKAGE_PATH}\" bestaat niet"
    echo "Maak een link aan via teams (zie readme.md of gebruik de"
    echo "\"-p\" vlag bij het commando"
    Usage
  }
  if [[ ${DEBUG} -eq 1 ]]
  then
    Display_title "Bekende variabelen"
    Display_vars PACKAGE_PATH "${PACKAGE_PATH}"
    Display_vars PROGRAM "${PROGRAM}"
    Display_vars PROGRAM_DIR "${PROGRAM_DIR}"
  fi
}

#--------------------------------------------------------------------------------
Edit_dummy_package()
{
# Change plist and pre- postuninstall  
# Input:
# $1: app name
# $2: source path
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x
  
  APP="$1"
  PROGRAM_DIR="$2"
  BELASTINGDIENST_APP_VERSION="$3"
  
    
  Display_info "Edit build-info.plist" 1
  # Change the identifier, name and version
  ed -s ${PROGRAM_DIR}/munkipkg_project/${APP}/build-info.plist > /dev/null <<- EOF
    /<key>version
    +1
    s=<string>.*</string>=<string>${BELASTINGDIENST_APP_VERSION}</string>=
w
q
EOF
  Check_rc $? "Changing dummy package plist failed" 31
}

#--------------------------------------------------------------------------------
Create_package()
{
# Change plist and pre- postuninstall  
# Input:
# $1: app name
# $2: source package path , the path where munki project is created
# $3: app package path (<one drive/packages/<app>/<version>)
# Return:
# -
#--------------------------------------------------------------------------------
  [[ ${DEBUG} -eq 2 ]] && set -x

  APP=$1
  Display_info "Create package"
  #APP_VERSION=$(/usr/libexec/PlistBuddy -c "Print :version" "${PROGRAM_DIR}/munkipkg_project/${APP}/build-info.plist")
  APP_PACKAGE_PATH="${PACKAGE_PATH}/${APP}/${BELASTINGDIENST_APP_VERSION}"
  

  NEW_PACKAGE=$(munkipkg "${PROGRAM_DIR}/munkipkg_project/${APP}" | grep 'Wrote package' | awk '{print $NF}')
  [[ -s "${NEW_PACKAGE}" ]]
  Check_rc $? "Cannot create munki package" 
  NEW_PACKAGE_NAME=$(echo ${NEW_PACKAGE} | awk -F/ '{print $NF}' )

  if [[ ${DEBUG} -eq 1 ]]
  then
    Display_title "Bekende variabelen"
    Display_vars APP "${APP}"
    Display_vars APP_VERSION "${APP_VERSION}"
    Display_vars PACKAGE_PATH "${PACKAGE_PATH}"
    Display_vars PROGRAM "${PROGRAM}"
    Display_vars PROGRAM_DIR "${PROGRAM_DIR}"
    Display_vars NEW_PACKAGE "${NEW_PACKAGE}"
    Display_vars NEW_PACKAGE_NAME "${NEW_PACKAGE_NAME}"
  fi
  
  Display_info "Create package dir" 
  mkdir -p "${APP_PACKAGE_PATH}"
  Check_rc $? "mkdir -p \"${APP_PACKAGE_PATH}\""

  Display_info "Copy package to package path" 
  mv ${NEW_PACKAGE} "${APP_PACKAGE_PATH}"
  Check_rc $? "Cannot move munki new package" 

  Display_info "Create package plist" 
  makepkginfo "${APP_PACKAGE_PATH}/${NEW_PACKAGE_NAME}" -c device_catalog \
    --category=Software --description=' ' --developer="${USER}" \
    --displayname="${APP}" --pkgvers=${BELASTINGDIENST_APP_VERSION} \
    > ${APP_PACKAGE_PATH}/${APP}-${BELASTINGDIENST_APP_VERSION}.plist
  Check_rc $? "Cannot create a new plist"

  
}

#--------------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------------
# Get arguments
GetArgs $@
[[ ${DEBUG} -eq 2 ]] && set -x

Check_used_tools
Edit_dummy_package "${APP}" "${PROGRAM_DIR}" "${BELASTINGDIENST_APP_VERSION}"
Create_package "${APP}"
