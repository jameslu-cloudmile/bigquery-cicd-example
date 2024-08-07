# GCP BigQuery CI/CD with Terraform and GitHub Workflows

## Project Overview
This project demonstrates a proof of concept for setting up continuous integration and continuous deployment (CI/CD) for a Google Cloud Platform (GCP) BigQuery project using Terraform and GitHub workflows. The goal is to automate infrastructure provisioning and deployment processes to ensure efficient and reliable data operations.

## Prerequisites
- Google Cloud Platform (GCP) account
- GCP Service Account with necessary permissions
- Terraform installed on your local machine
- GitHub account

## Setup Instructions

### GCP Service Account
1. **Create a Service Account**:
   - Go to the [GCP Console](https://console.cloud.google.com/).
   - Navigate to `IAM & Admin` > `Service Accounts`.
   - Click `Create Service Account` and provide a name and description.

2. **Assign Permissions**:
   - Add the following roles to the service account:
     - BigQuery Data Editor
     - BigQuery Job User
     - Storage Admin (for creating Bucket only)
     - Storage Object User

3. **Create and Download Keys**:
   - Navigate to the `Keys` section of the service account.
   - Click `Add Key` > `Create New Key` and download the JSON key file. Save this file securely as it will be used for authentication.

4. **Store the Key**:
   - Save the downloaded JSON key file in the project root directory as `credential.json`.

### Terraform Configuration
1. **Set Up Terraform**:
   - Install Terraform from the [official website](https://www.terraform.io/downloads.html).
   - Initialize Terraform in your project directory:
     ```bash
     terraform init
     ```

2. **Configure Terraform Provider**:
   - In the `providers.tf` file, configure the GCP provider:
     ```hcl
     provider "google" {
       project     = "your-gcp-project-id"
       region      = "your-gcp-region"
     }
     ```

3. **Define BigQuery Resources**:
   - In the `bigquery.tf` file, define your BigQuery datasets, tables, and other resources:
     ```hcl
     resource "google_bigquery_dataset" "your-dataset-name" {
       dataset_id    = "your-dataset-name"
       friendly_name = "your-dataset-name"
       description   = "This is demo dataset for Terraform"
       location      = "your-gcp-region"

       labels = {
         env = "terraform"
         pic = "jon"
       }
     }

     resource "google_bigquery_table" "your-table-name" {
       dataset_id = google_bigquery_dataset.your-dataset-name.dataset_id
       table_id   = "your-table-name"

       labels = {
         env = "terraform"
         pic = "jon"
       }

       view {
         query          = file("bigquery/your-dataset-name/your-table-name.sql")
         use_legacy_sql = false
       }
     }
     ```


### GitHub Workflows
1. **Create GitHub Workflow File**:
   - In your GitHub repository, navigate to `.github/workflows` and create a file named `ci-cd.yml`:
     ```yaml
     name: 'Terraform'

     on:
       push:
         branches:
           - main
       pull_request:

     jobs:
       terraform:
         name: 'Terraform'
         runs-on: ubuntu-latest
         environment: production

         defaults:
           run:
             shell: bash

         steps:
         - name: Checkout
           uses: actions/checkout@v2

         - name: Setup Terraform
           uses: hashicorp/setup-terraform@v1

         - name: Terraform Init
           run: terraform init
           env:
             GOOGLE_CREDENTIALS: ${{ secrets.GOOGLE_CREDENTIALS }}

         - name: Terraform Format
           run: terraform fmt -check

         - name: Terraform Plan
           run: terraform plan
           env:
             GOOGLE_CREDENTIALS: ${{ secrets.GOOGLE_CREDENTIALS }}

         - name: Terraform Apply
           if: github.ref == 'refs/heads/main' && github.event_name == 'push'
           run: terraform apply -auto-approve
           env:
             GOOGLE_CREDENTIALS: ${{ secrets.GOOGLE_CREDENTIALS }}
     ```
2. **Set GitHub Secrets**:
   - In your GitHub repository, navigate to `Settings` > `Secrets and variables` > `Actions` > `Repository secrets`.
   - Create a new secret named `GOOGLE_CREDENTIALS` and paste the contents of your `credential.json` file.

## Usage
To deploy the infrastructure, simply push changes to the `main` branch of your GitHub repository. The GitHub workflow will automatically trigger and apply the Terraform configurations. On pull request events, the workflow will run `terraform init`, `terraform fmt`, and `terraform plan` to deploy automatically.

Users can edit the SQL file located at `bigquery/views/your-table-name.sql` to manipulate the data and export it to the data table defined in `bigquery.tf`. Once changes are made to the SQL file, pushing these changes to the `main` branch will trigger the CI/CD pipeline to update the BigQuery dataset and table accordingly.

## References
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Google Cloud BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [hashicorp/setup-terraform GitHub Action](https://github.com/hashicorp/setup-terraform)
- [IAM basic and predefined roles reference](https://cloud.google.com/iam/docs/understanding-roles)
- [Version control Big Query with Terraform (with CI/CD too)](https://towardsdatascience.com/version-control-big-query-with-terraform-with-ci-cd-too-a4bbffb25ad9)
