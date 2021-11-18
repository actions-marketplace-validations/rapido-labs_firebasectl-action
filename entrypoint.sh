#!/bin/sh
dir_flag="--input-dir"
echo $PATH
if [ "${INPUT_FIREBASE_CTL_ACTION}" == "get" ]; then
    dir_flag="--output-dir"
fi
firebasectl_output=$(firebase-ctl "$INPUT_FIREBASE_CTL_ACTION" remote-config $dir_flag "$INPUT_FIREBASE_CTL_DIR")

firebasectl_exit_code=${?}

    # exit code 0 - success
    if [ ${firebasectl_exit_code} -eq 0 ];then
        firebasectl_comment_status="Success"
        echo "firebasectl: info: successful ${INPUT_FIREBASE_CTL_ACTION} on ${INPUT_FIREBASE_CTL_DIR}."
        echo $firebasectl_output
        echo
    fi

    # exit code !0 - failure
    if [ ${firebasectl_exit_code} -ne 0 ]; then
        firebasectl_comment_status="Failed"
        echo "firebasectl: error: failed ${INPUT_FIREBASE_CTL_ACTION} on ${INPUT_FIREBASE_CTL_DIR}."
        echo ${firebasectl_output}
        echo
    fi

    # comment if firebasectl failed
    if [ "${GITHUB_EVENT_NAME}" == "pull_request" ] && [ ${firebasectl_exit_code} -ne 0 ]; then
        firebasectl_comment_wrapper="#### \`firebasectl\` ${firebasectl_comment_status}
<details><summary>Show Output</summary>

\`\`\`
${firebasectl_output}
 \`\`\`
</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, firebasectl: \`${INPUT_FIREBASE_CTL_DIR}\`*"
    
        echo "firebasectl: info: creating json"
        firebasectl_payload=$(echo "${firebasectl_comment_wrapper}" | jq -R --slurp '{body: .}')
        firebasectl_comment_url=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
        echo "firebasectl: info: commenting on the pull request"
        echo "${firebasectl_payload}" | curl -s -S -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" --header "Content-Type: application/json" --data @- "${firebasectl_comment_url}" > /dev/null
    fi
echo ::set-output name=firebasectl_output::${firebasectl_output}
exit ${firebasectl_exit_code}