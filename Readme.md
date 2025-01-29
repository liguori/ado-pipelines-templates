# Introduction

This repository contains examples of Azure DevOps Pipelines templates that can be shared with Project Teams for governance during the execution of PR, CI and CD automation.

## Azure Pipelines Templates

The templates are designed to be used across multiple projects and can be referenced in the `azure-pipelines.yml` file of the project repository:
 
[Templates](/ado-pipelines-template)


## Example of usage of the templates

An example of how to use the templates in an `azure-pipelines.yml` file is shown below:

[Usage](/demo-project/Pipelines)


## Disclaimer
The pipeline templates in this repository are not production ready, it can be incomplete, not working and should be considered as an example of the Azure Pipeline YAML syntax and Tasks to use when referencing templates and their possible implementations.

## Docs References
[Repository Resoruce](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/resources?view=azure-devops#repository-resource-definition)

[Template usage reference](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/templates?pivots=templates-extends)

[Use templates for security](https://learn.microsoft.com/en-us/azure/devops/pipelines/security/templates?view=azure-devops)

[Define approvals and checks - Required template](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#required-template)