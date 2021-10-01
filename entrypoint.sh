#!/bin/sh -l

# Displaying options
echo "Running Terrascan GitHub Action with the following options:"
echo "INPUT_IAC_DIR=${INPUT_IAC_DIR}"
echo "INPUT_IAC_TYPE=${INPUT_IAC_TYPE}"
echo "INPUT_IAC_VERSION=${INPUT_IAC_VERSION}"
echo "INPUT_NON_RECURSIVE=${NON_RECURSIVE}"
echo "INPUT_POLICY_TYPE=${INPUT_POLICY_TYPE}"
echo "INPUT_POLICY_PATH=${INPUT_POLICY_PATH}"
echo "INPUT_SKIP_RULES=${INPUT_SKIP_RULES}"
echo "INPUT_CONFIG_PATH=${INPUT_CONFIG_PATH}"
echo "INPUT_SARIF_UPLOAD=${INPUT_SARIF_UPLOAD}"
echo "INPUT_VERBOSE=${INPUT_VERBOSE}"
echo "INPUT_FIND_VULNERABILITIES=${INPUT_FIND_VULNERABILITIES}"
echo "GITHUB_SERVER_URL"=${GITHUB_SERVER_URL}

# Creating arguments for terrascan
args=""
if [ "x${INPUT_IAC_DIR}" != "x" ]; then
    args="${args} -d ${INPUT_IAC_DIR}"
fi
if [ "x${INPUT_IAC_TYPE}" != "x" ]; then
    args="${args} -i ${INPUT_IAC_TYPE}"
fi
if [ "x${INPUT_IAC_VERSION}" != "x" ]; then
    args="${args} --iac-version ${INPUT_IAC_VERSION}"
fi
if [ "x${INPUT_NON_RECURSIVE}" != "x" ]; then
    args="${args} --non-recursive"
fi
if [ "x${INPUT_POLICY_PATH}" != "x" ]; then
    args="${args} -p ${INPUT_POLICY_PATH}"
fi
if [ "x${INPUT_POLICY_TYPE}" != "x" ]; then
    args="${args} -t ${INPUT_POLICY_TYPE}"
fi
if [ "x${INPUT_SKIP_RULES}" != "x" ]; then
    args="${args} --skip-rules='${INPUT_SKIP_RULES}'"
fi
if [ "x${INPUT_CONFIG_PATH}" != "x" ]; then
    args="${args} -c ${INPUT_CONFIG_PATH}"
fi
if [ ${INPUT_VERBOSE} == true ]; then
    args="${args} -v"
fi
if [ ${INPUT_FIND_VULNERABILITIES} == true ]; then
    args="${args} --find-vuln"
fi
if [ "x${INPUT_GITHUB_OAUTH_TOKEN}" != "x" ]; then
    git config --global url."https://${INPUT_GITHUB_OAUTH_TOKEN}@${GITHUB_SERVER_URL#"https://"}".insteadOf "${GITHUB_SERVER_URL}"
fi

#Executing terrascan
echo "Executing terrascan as follows:"
echo "terrascan scan ${args}"
terrascan scan ${args}
res=$?

if [ "x${INPUT_SARIF_UPLOAD}" != "x" ]; then
    echo "Generating SARIF file"
    terrascan scan ${args} -o sarif > terrascan.sarif
fi

# Handling exit code
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi
