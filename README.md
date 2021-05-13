# Prisma Cloud Compute SELF-HOSTED POC Defender deploy
## Assumptions

* You're using the SELF-HOSTED VERSION OF PRISMA CLOUD COMPUTE
* You're using ubuntu 20.04
* You're able to reach your PCC console from your ubuntu 20.04 machine
* You would know how to harden this process if working in a production environment.
* If you do decide to keep the keys/password/username in this script, then it's critical you:
  
   * Add it to your `.gitignore` (if using git) file and `chmod 700 defender_deplooy.bash` between steps 2 and 3 below so that others can't read, write, or excute it.

## Instructions
* Step 1: `git clone https://github.com/Kyle9021/pcc_defender_api_deploy`
* Step 2: `cd pcc_defender_api_deploy/`
* Step 3: `nano defender_deploy.bash` and replace `<IP_ADDRESS_OR_HOSTNAME>`, `<PCC_USERNAME>`, `<PCC_USERNAME_PASSWORD>`, `<PORT_MAPPED_TO_PORT_8084_OF_CONSOLE>`, `<PORT_MAPPED_TO_PORT_8083_OF_CONSOLE>`, and `<DEFENDER_DEPLOY_TYPE>` with the appropriate values from your pcc console.
* Step 4: Install jq if you dont have it `sudo apt update && upgrade -y` then `sudo apt-get install jq`
* Step 5: `bash defender_deploy.bash`

Written in Bash for portability. Please modify and distribute freely.

## Links to reference

* [Why this matters](https://www.softwareone.com/en/blog/all-articles/2020/11/24/oracle-java-licensing)
* [Official JQ Documentation](https://stedolan.github.io/jq/manual/)
* [Grep Documentation](https://www.gnu.org/software/grep/manual/grep.html)
* [Exporting variables for API Calls and why I choose bash](https://apiacademy.co/2019/10/devops-rest-api-execution-through-bash-shell-scripting/)
* [PAN development site](https://prisma.pan.dev/)
