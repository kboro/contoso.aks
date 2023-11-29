# AKS Terraform development using VSCode and Azure DevOps Pipeline

## Local Development and Testing:

0. Request access to StorageAccount blob container where tf state file exists.
1. Create feature/* branch
2. From the terminal in VSCode, initialize the Terraform working directory using the `terraform init` command.
3. Validate the files with `terraform validate`, and format your code using `terraform fmt`.
4. Create an execution plan with `terraform plan`. This will show you the actions that Terraform will take to create your infrastructure.
5. Once the terraform plan appears correct, create a Pull Request from the 'feature/*' branch to the 'main' branch.
6. The Pull Request contains a mandatory "Build Validation" step, which provides the Terraform Plan Output and Static Code Analysis report.

## Deploying with Azure DevOps Pipeline:

1. Once the PR is merged with the 'main' branch, the 'aks-provision' Azure Pipeline is triggered.
2. After the "terraform plan" job, the Subscription owner is notified and decides whether to proceed with "Terraform Apply".
3. Once approval is given, "Terraform Apply" is executed.

**Note:** 
1. Always run `terraform plan` and review it carefully before applying changes, especially in a production environment. Always check the results of your deployments to ensure that everything was created as expected.
2. Developers are not permitted to execute 'terraform apply' locally due to having only 'Reader' permissions on the Subscription. Any changes to the infrastructure can ONLY be deployed via the 'aks-provision' Azure DevOps Pipeline.