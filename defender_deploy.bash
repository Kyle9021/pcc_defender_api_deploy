
#!/bin/bash

## Set the following variables to the correct values short description before each value

# the hostname of the console or IP Address
pcc_hostname=<IP_ADDRESS_OR_HOSTNAME>

# prisma cloud user name. Must be defender manager or above. Recommending that it's a CLI type user. 
pcc_cli_user=<PCC_USERNAME>

# Password for that CLI user. For testing it's okay to use your admin account in a non-prod deployment
pcc_cli_user_password=<PCC_USERNAME_PASSWORD>

# Port mapped to 8084
pcc_websocket_port=<PORT_MAPPED_TO_PORT_8084_OF_CONSOLE>

# Port mapped to 8083 on console
pcc_mgmt_port=<PORT_MAPPED_TO_PORT_8083_OF_CONSOLE>

# Assign one of the following values: swarm_linux_def, swarm_mac_def, openshift_mac_def, openshift_linux_def, k8_mac_def, k8_linux_def, linux_host_def, or linux_container_def
# It's case sensitive
pcc_defender_deploy_type=<SET_THIS_TO_ONE_OF_THE_OPTIONS_ABOVE>

# Don't change variables below. I set them to avoid issues where I needed to reference variables within single quotes
pcc_api_var="{\"username\":\""${pcc_cli_user}"\", \"password\":\""${pcc_cli_user_password}"\"}"
pcc_api_port_var="{\"port\":"${pcc_websocket_port}"}"

# This is the part which creates the authorization token. One might consider separating this part in a different script and exporting the variable for more robust security
pcc_api_token=$(curl -k -H "Content-Type: application/json" -d "${pcc_api_var}" https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/authenticate | jq -r '.token')


# Checks the user input
if [ "${pcc_defender_deploy_type}" != "swarm_linux_def" ] && \
[ "${pcc_defender_deploy_type}" != "swarm_mac_def" ] && \
[ "${pcc_defender_deploy_type}" != "openshift_mac_def" ] && \
[ "${pcc_defender_deploy_type}" != "openshift_linux_def" ] && \
[ "${pcc_defender_deploy_type}" != "k8_mac_def" ] && \
[ "${pcc_defender_deploy_type}" != "k8_linux_def" ] && \
[ "${pcc_defender_deploy_type}" != "linux_host_def" ] && \
[ "${pcc_defender_deploy_type}" != "linux_container_def" ]; then \

        echo "nano the script and assign the pcc_defender_deploy_type variable to either: swarm_linux_def, swarm_mac_def, openshift_mac_def, openshift_linux_def, k8_mac_def, k8_linux_def, linux_host_def, linux_container_def"

        exit
# linux_container_def
elif [ "${pcc_defender_deploy_type}" = "linux_container_def" ]; then
        curl -sSL -k --header "authorization: Bearer ${pcc_api_token}" \
        -X POST https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/scripts/defender.sh -d  \
        "${pcc_api_port_var}" | sudo bash -s -- -c "${pcc_hostname}" -d "none"
        exit

# linux_host_def
elif [ "${pcc_defender_deploy_type}" = "linux_host_def" ]; then
        curl -sSL -k --header "authorization: Bearer ${pcc_api_token}" \
        -X POST https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/scripts/defender.sh -d  \
        "${pcc_api_port_var}" | sudo bash -s -- -c "${pcc_hostname}" -d "none"   --install-host
        exit


# k8_linux_def
elif [ "${pcc_defender_deploy_type}" = "k8_linux_def" ]; then
        if [[ ! -f ./twistcli || $(./twistcli --version) != *""${pcc_console_version}""* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/twistcli > \
                twistcli; chmod +x twistcli; fi; \
                ./twistcli defender install kubernetes \
                --namespace twistlock --monitor-service-accounts \
                --token "${pcc_api_token}" \
                --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address ""${pcc_hostname}":"${pcc_websocket_port}""
                        rm twistcli
        exit

# k8_mac_def
elif [ "${pcc_defender_deploy_type}" = "k8_mac_def" ]; then
        if [[ ! -f ./twistcli-darwin || $(./twistcli-darwin --version) != *""${pcc_console_version}""* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/osx/twistcli > \
                twistcli-darwin; chmod +x twistcli-darwin; fi; \
                ./twistcli-darwin defender install kubernetes \
                --namespace twistlock --monitor-service-accounts \
                --token "${pcc_api_token}" \
                --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address ""${pcc_hostname}":"${pcc_websocket_port}""
                        rm twistcli-darwin
        exit

# openshift_linux_def
elif [ "${pcc_defender_deploy_type}" = "openshift_linux_def" ]; then
        if [[ ! -f ./twistcli || $(./twistcli --version) != *"${pcc_console_version}"* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/twistcli > \
                twistcli; chmod +x twistcli; fi; \
                ./twistcli defender install openshift \
                --namespace twistlock --monitor-service-accounts \
                --token "${pcc_api_token}" --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address "${pcc_hostname}":"${pcc_websocket_port}"  \
                --selinux-enabled
        exit


# openshift_mac_def
elif [ "${pcc_defender_deploy_type}" = "openshift_mac_def" ]; then
        if [[ ! -f ./twistcli-darwin || $(./twistcli-darwin --version) != *"${pcc_console_version}"* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/osx/twistcli > \
                twistcli-darwin; chmod +x twistcli-darwin; fi; \
                ./twistcli-darwin defender install openshift \
                --namespace twistlock --monitor-service-accounts \
                --token "${pcc_api_token}" --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address ""${pcc_hostname}":"${pcc_websocket_port}""  --selinux-enabled
        exit

# swarm_linx_def
elif [ "${pcc_defender_deploy_type}" = "swarm_linux_def" ]; then
        if [[ ! -f ./twistcli || $(./twistcli --version) != *"${pcc_console_version}"* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/twistcli > \
                twistcli; chmod +x twistcli; fi; \
                sudo ./twistcli defender install swarm --token "${pcc_api_token}" \
                --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address ""${pcc_hostname}":"${pcc_websocket_port}""
        exit

# swarm_mac_def
elif [ "${pcc_defender_deploy_type}" = "swarm_mac_def" ]; then
        if [[ ! -f ./twistcli-darwin || $(./twistcli-darwin --version) != *"${pcc_console_version}"* ]]; then
                curl --progress-bar -L -k --header "authorization: Bearer ${pcc_api_token}" \
                https://"${pcc_hostname}":"${pcc_mgmt_port}"/api/v1/util/osx/twistcli > twistcli-darwin; chmod +x twistcli-darwin; fi; \
                sudo ./twistcli-darwin defender install swarm --token "${pcc_api_token}" \
                --address "https://"${pcc_hostname}":"${pcc_mgmt_port}"" \
                --cluster-address ""${pcc_hostname}":"${pcc_websocket_port}""
        exit
fi
