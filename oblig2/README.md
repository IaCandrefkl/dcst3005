
# Mappestruktur

- **backend-configs** — Backend tfvars-fil for hvert miljø - Nøkler: resource_group_name, storage_account_name, container_name, key, use_azuread_auth
  - backend-dev.tfvars
  - backend-prod.tfvars
  - backend-test.tfvars

- **environments** — tfvars-fil for hvert miljø - Nøkler: environment, location, project_name, account_tier, replication_type
  - dev.tfvars
  - prod.tfvars
  - test.tfvars

- **scripts** — PowerShell-skript for å bygge, deploye og destroye infrastruktur lokalt med buildOnce–deployMany metoden  
  - build.ps1
  - clean.ps1
  - deploy.ps1

- **shared** — Felles backend-konfigurasjon  
  - backend.hcl

- **terraform** — Selve Terraform-koden  
  - .terraform.lock.hcl
  - backend.tf
  - main.tf
  - outputs.tf
  - variables.tf
  - versions.tf

- **workflows** - Workflows ligger egentlig i .github/workflows. Disse filene er bare kopiert hit for oversiktens skyld.  
  - terraform-ci.yml - Kjører når en pull request opprettes mot main. Validerer koden og kjører plan i hvert miljø.
  - terraform-cd.yml - Kjøres på push til main. Deployer koden til hvert miljø, med krav om godkjenning før produksjon deployes.

# Scripts

Skriptene i scripts mappen bruker for å deploye lokalt. `build.ps1` validerer og bygger koden inn i en zip-fil. `deploy.ps1` deployer zip filen til et valgt miljø. `clean.ps1` destroyer infrastrukturen.

## Kjør scripts

Build
```powershell
.\scripts\build.ps1
```
Dette vil lage en `terraform-<commit-hash>.zip` fil.

Deploy
```powershell
.\scripts\deploy.ps1 -Environment <env - dev | test | prod> -Artifact <zip fil navn - fks terraform-8e56097.zip>
```

Clean
```powershell
.\scripts\clean.ps1 -Environment <env - dev | test | prod> -Artifact <zip fil navn - fks terraform-8e56097.zip>
```
Du vil få opp alternativer for hva du ønsker å destroye.

# Arbeidsflyt

Dette er en forklaring arbeidsflyten som bør følges for dette prosjektet.

## Opprett en pull request

Sørg for at du er i main:
```bash
git checkout main
git pull
```

Lag en ny branch
```bashbash
git checkout -b <branch-navn>
```

Gjør endringene dine i `terraform` mappen, commit og push
```bash
git add .
git commit -m "<commit-melding>"
git push --set-upstream origin <branch-navn>
```

Opprett en pull request mot main i GitHub.

## CI

CI kjøres automatisk når en pull request lages mot main. Den validerer først Terraform koden med `terraform fmt` og `terraform validate`. Så kjøres en plan for hvert miljø. Output med hvilke endringer som vil skje i hvert miljø vises i pull requesten.

Hvis CI feiler, eller de planlagte endringene ser feil ut, oppdater koden og push endringene:
```bashgit add .
git commit -m "<commit-melding>"
git push
```

## CD

CD kjøres automatisk når endringer blir pushet til main. Den applyer terraform koden i hvert miljø. Først deployes dev og test. Deploy til prod krever godkjenning, før det: Gå i Azure og sjekk at alt ser bra ut i de miljøene. Deretter godkjenner du deploy til prod i GitHub Actions.
