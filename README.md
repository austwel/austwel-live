<p align="center"><h1 align="center">austwel-live</h1></p>
<p align="center">
	<em><code>❯ personal cloud resource state management</code></em>
</p>
<p align="center">
	<img src="https://img.shields.io/github/license/austwel/austwel-live?style=default&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
	<img src="https://img.shields.io/github/last-commit/austwel/austwel-live?style=default&logo=git&logoColor=white&color=0080ff" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/austwel/austwel-live?style=default&color=0080ff" alt="repo-top-language">
	<img src="https://img.shields.io/github/languages/count/austwel/austwel-live?style=default&color=0080ff" alt="repo-language-count">
</p>
<p align="center"><!-- default option, no dependency badges. -->
</p>
<p align="center">
	<!-- default option, no dependency badges. -->
</p>
<br>

##  Table of Contents

- [ Overview](#-overview)
- [ Features](#-features)
- [ Project Structure](#-project-structure)
  - [ Project Index](#-project-index)
- [ Getting Started](#-getting-started)
  - [ Prerequisites](#-prerequisites)
  - [ Installation](#-installation)
  - [ Usage](#-usage)
  - [ Testing](#-testing)
- [ Project Roadmap](#-project-roadmap)
- [ Contributing](#-contributing)
- [ License](#-license)
- [ Acknowledgments](#-acknowledgments)

---

##  Overview

This project uses Terraform to define, provision, and manage AWS resources in a consistent and repeatable way. The infrastructure is defined as code, allowing for version control, collaboration, and automated deployments.

---

##  Project Structure

```sh
└── austwel-live/
    ├── common           # Common provider and terraform configuration
    ├── live             # Live definition of the aws resources
    └── modules          # Modules to assist in managing live resources
```


###  Project Index
<details open>
	<summary><b><code>AUSTWEL-LIVE/</code></b></summary>
	<details> <!-- modules Submodule -->
		<summary><b>modules</b></summary>
		<blockquote>
      <table>
        <tr>
          <td><b><a href='https://github.com/austwel/austwel-live/blob/master/modules/ebs'>ebs</a></b></td>
				  <td><code>❯ Create an EBS volume.</code></td>
        </tr>
        <tr>
          <td><b><a href='https://github.com/austwel/austwel-live/blob/master/modules/asg'>asg</a></b></td>
				  <td><code>❯ Configure an autoscaling group.</code></td>
        </tr>
        <tr>
          <td><b><a href='https://github.com/austwel/austwel-live/blob/master/modules/minecraft_server'>minecraft_server</a></b></td>
				  <td><code>❯ Provision a minecraft server on an asg with spot or on-demand instances using curseforge modpacks.</code></td>
        </tr>
        <tr>
          <td><b><a href='https://github.com/austwel/austwel-live/blob/master/modules/ec2'>ec2</a></b></td>
				  <td><code>❯ Provision ec2 instances.</code></td>
        </tr>
        <tr>
          <td><b><a href='https://github.com/austwel/austwel-live/blob/master/modules/launch_template'>launch_template</a></b></td>
				  <td><code>❯ Configurable autoscaling group launch template for provisioning spot and on-demand instances.</code></td>
        </tr>
      </table>
		</blockquote>
	</details>
	<details> <!-- common Submodule -->
		<summary><b>common</b></summary>
		<blockquote>
			<table>
			<tr>
				<td><b><a href='https://github.com/austwel/austwel-live/blob/master/common/provider_aws.tf'>provider_aws.tf</a></b></td>
				<td><code>❯ Common AWS provider config.</code></td>
			</tr>
			<tr>
				<td><b><a href='https://github.com/austwel/austwel-live/blob/master/common/terraform.tf'>terraform.tf</a></b></td>
				<td><code>❯ Common terraform config.</code></td>
			</tr>
			</table>
		</blockquote>
	</details>
	<details> <!-- live Submodule -->
		<summary><b>live</b></summary>
		<blockquote>
			<table>
			<tr>
				<td><b><a href='https://github.com/austwel/austwel-live/blob/master/live/provider_aws.tf'>provider_aws.tf</a></b></td>
				<td><code>❯ Live AWS provider config.</code></td>
			</tr>
			<tr>
				<td><b><a href='https://github.com/austwel/austwel-live/blob/master/live/main.tf'>main.tf</a></b></td>
				<td><code>❯ Root module to manage configurations of all submodules.</code></td>
			</tr>
			</table>
			<details>
				<summary><b>minecraft</b></summary>
				<blockquote>
					<details>
						<summary><b>all-the-mods-10</b></summary>
						<blockquote>
							<table>
							<tr>
								<td><b><a href='https://github.com/austwel/austwel-live/blob/master/live/minecraft/all-the-mods-10/main.tf'>main.tf</a></b></td>
								<td><code>❯ A provisioned minecraft server running All The Mods 10.</code></td>
							</tr>
							</table>
						</blockquote>
					</details>
					<details>
						<summary><b>ftb-oceanblock-2</b></summary>
						<blockquote>
							<table>
							<tr>
								<td><b><a href='https://github.com/austwel/austwel-live/blob/master/live/minecraft/ftb-oceanblock-2/main.tf'>main.tf</a></b></td>
								<td><code>❯ A provisioned minecraft server running FTB Oceanblock 2.</code></td>
							</tr>
							</table>
						</blockquote>
					</details>
				</blockquote>
			</details>
		</blockquote>
	</details>
</details>

---
##  Getting Started

###  Prerequisites

Before getting started, ensure your runtime environment meets the following requirements:---

* Terraform (v1.3.0+)
* AWS CLI and credentials configured in ~/.aws/credentials
* Git

###  Installation

Install using the following method:

1. Clone the austwel-live repository:
```sh
❯ git clone https://github.com/austwel/austwel-live
```

2. Navigate to the root module directory:
```sh
❯ cd austwel-live/live
```

3. Initialise the terraform project:
```sh
❯ terraform init
```

###  Usage
Plan the changes using the following command:
```sh
❯ terraform plan -out=tfplan
```

Apply them using:
```sh
❯ terraform apply tfplan
```

---
##  Project Roadmap

- [X] **`Task 1`**: <strike>Easily manage and provision modded minecraft servers.</strike>
- [X] **`Task 2`**: <strike>Incoporate the [Cloudflare](https://developers.cloudflare.com/terraform/) terraform provider to manage DNS records to elastic IPs, or just public ec2 ip addresses.</strike>
- [ ] **`Task 3`**: Implement more modpack types, expanding upon just curseforge.
- [ ] **`Task 4`**: Expand to cover more aws resources.

---

##  Contributing

- **💬 [Join the Discussions](https://github.com/austwel/austwel-live/discussions)**: Share your insights, provide feedback, or ask questions.
- **🐛 [Report Issues](https://github.com/austwel/austwel-live/issues)**: Submit bugs found or log feature requests for the `austwel-live` project.
- **💡 [Submit Pull Requests](https://github.com/austwel/austwel-live/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using git.
   ```sh
   git clone https://github.com/austwel/austwel-live
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch.
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="left">
   <a href="https://github.com{/austwel/austwel-live/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=austwel/austwel-live">
   </a>
</p>
</details>

---

##  License

This project is protected under the [MIT License]([https://choosealicense.com/licenses](https://choosealicense.com/licenses/mit/)) License. For more details, refer to the [LICENSE](https://github.com/austwel/austwel-live/blob/main/LICENSE) file.

---

##  Acknowledgments

- CB

---
