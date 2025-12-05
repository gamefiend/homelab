# Pre-commit Setup

This document describes how to set up and use pre-commit hooks for this repository.

## Overview

The pre-commit hooks in this repository ensure code quality and consistency by:
- Formatting Terraform files using `terraform fmt`
- Validating Terraform configurations using `terraform validate`

## Installation

1. Install pre-commit:
   ```bash
   # Using Homebrew (macOS)
   brew install pre-commit

   # Using pip (Python)
   pip install pre-commit
   ```

2. Install the pre-commit hooks in this repository:
   ```bash
   pre-commit install
   ```

## Usage

### Automatic Execution

The hooks will run automatically when you try to commit changes to any `.tf` files. If the hooks fail, the commit will be blocked until you fix the issues.

### Manual Execution

You can also run the hooks manually:
```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run
```

### Manual Commands

If you want to run the formatting or validation without using pre-commit:

```bash
# Format Terraform files
terraform fmt

# Validate Terraform configuration
terraform validate
```

## Configuration

The pre-commit configuration is stored in `.pre-commit-config.yaml` at the root of the repository. We use the official Terraform pre-commit hooks from [antonbabenko/pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform).

- `terraform_fmt`: Formats Terraform files
- `terraform_validate`: Validates Terraform configurations

The hooks are configured to:
- Run on files with `.tf` extensions
- Use the system's PATH to find the `terraform` executable
- Format and validate Terraform configurations 