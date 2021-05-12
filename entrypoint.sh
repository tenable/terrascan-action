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

# Executing terrascan
echo "Executing terrascan as follows:"
echo "terrascan scan ${args}"
terrascan scan ${args}

# Handling exit code
res=$?
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi
