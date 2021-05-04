## Assumptions

* You're using the SELF-HOSTED VERSION OF PRISMA CLOUD COMPUTE
* You're using ubuntu 20.04
* You're able to reach your PCC console from your ubuntu 20.04 machine
* You would know how to harden this process if working in a production environment.

## Instructions
* Step 1: `git clone https://github.com/Kyle9021/pcc_defender_api_deploy`
* Step 2: `cd pcc_defender_api_deploy/`
* Step 3: `nano defender_deploy.bash` and replace `<IP_ADDRESS_OR_HOSTNAME>`, `<PCC_USERNAME>`, `<PCC_USERNAME_PASSWORD>`, `<PORT_MAPPED_TO_PORT_8084_OF_CONSOLE>`, `<PORT_MAPPED_TO_PORT_8083_OF_CONSOLE>`, and `<DEFENDER_DEPLOY_TYPE>` with the appropriate values from your pcc console.
* Step 4: Install jq if you dont have it `sudo apt update && upgrade -y` then `sudo apt install jq`
* Step 5: `bash defender_deploy.bash`

Written in Bash for portability. Please modify and distribute freely.
