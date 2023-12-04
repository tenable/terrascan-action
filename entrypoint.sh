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
echo "INPUT_WEBHOOK_URL=${INPUT_WEBHOOK_URL}"

# Retrieving SCM URL, Repository URL and REF from CI variables
if [ "x${GITHUB_SERVER_URL}" != "x" ]; then
    # Handling GitHub
    SCM_SERVER_URL="${GITHUB_SERVER_URL}"
    REPO_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}.git"

    if [ "x${GITHUB_REF}" != "x" ]; then
        REF_NAME="$(echo ${GITHUB_REF#refs/heads/})"
    else
        REF_NAME="$(echo ${GITHUB_HEAD_REF#refs/heads/})"
    fi
elif [ "x${CI_SERVER_URL}" != "x" ]; then
    # Handling GitLab
    SCM_SERVER_URL="${CI_SERVER_URL}"
    REPO_URL="https://${CI_REPOSITORY_URL#https:*@}"
    REF_NAME="${CI_COMMIT_REF_NAME}"

elif [ "x${BITBUCKET_GIT_HTTP_ORIGIN}" != "x" ]; then
    # Handling Bitbucket
    SCM_SERVER_URL="https://$(echo ${BITBUCKET_GIT_HTTP_ORIGIN#"http://"} | cut -d'/' -f 1)"
    REPO_URL="${SCM_SERVER_URL}/${BITBUCKET_REPO_FULL_NAME}.git"

    if [ "x${BITBUCKET_BRANCH}" != "x" ]; then
        REF_NAME="${BITBUCKET_BRANCH}"
    else
        REF_NAME="${BITBUCKET_TAG}"
    fi
else
    echo "WARNING: No SCM server URL found."
fi

echo "SCM_SERVER_URL=${SCM_SERVER_URL}"
echo "REPO_URL=${REPO_URL}"
echo "REF_NAME=${REF_NAME}"

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
if [ ${INPUT_VERBOSE} ]; then
    args="${args} -v"
fi
if [ ${INPUT_FIND_VULNERABILITIES} ]; then
    args="${args} --find-vuln"
fi
if [ "x${INPUT_SCM_TOKEN}" != "x" ]; then
    git config --global url."https://${INPUT_SCM_TOKEN}@${SCM_SERVER_URL#"https://"}".insteadOf "${SCM_SERVER_URL}"
fi
if [ "x${INPUT_WEBHOOK_URL}" != "x" ]; then
    args="${args} --webhook-url ${INPUT_WEBHOOK_URL}"
fi
if [ "x${INPUT_WEBHOOK_TOKEN}" != "x" ]; then
    args="${args} --webhook-token ${INPUT_WEBHOOK_TOKEN}"
fi
if [ "x${REPO_URL}" != "x" ]; then
    args="${args} --repo-url ${REPO_URL}"
    args="${args} --repo-ref ${REF_NAME}"
fi

## Generate action outputs
echo "{err}=${res}" >> $GITHUB_OUTPUT
command="terrascan scan ${args}"
result=$( $command 2>&1)
result="${result//'%'/'%25'}"
result="${result//$'\n'/'%0A'}"
result="${result//$'\r'/'%0D'}"

echo "{result}=${result}" >> $GITHUB_OUTPUT

#Executing terrascan
echo "Executing terrascan as follows:"
echo "terrascan scan ${args}"
terrascan scan ${args} --log-output-dir $(pwd)
res=$?
cat scan-result.txt >> $GITHUB_STEP_SUMMARY


if [ "x${INPUT_SARIF_UPLOAD}" != "x" ]; then
    echo "Generating SARIF file"
    terrascan scan ${args} -o github-sarif > terrascan.sarif
fi

# Handling exit code
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi
