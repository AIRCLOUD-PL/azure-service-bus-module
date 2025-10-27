# azure-service-bus-module

Azure Terraform module for service-bus-module.

## 🚀 Usage

```hcl
module "service-bus-module" {
  source = "github.com/AIRCLOUD-PL/azure-service-bus-module"
  
  # Add your variables here
}
```

## 📋 Requirements

- Terraform >= 1.5.0
- Azure Provider >= 4.0
- Go >= 1.22 (for testing)

## 📖 Documentation

See the [examples](./examples/) directory for usage examples.

## 🧪 Testing

Run tests with:
```bash
cd test
go mod download
go test -v -timeout 30m
```

## 🔒 Security

This module includes:
- Security policies validation
- Compliance checks
- Best practices enforcement

See [SECURITY.md](./SECURITY.md) for details.

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

## 📄 License

This project is licensed under the MIT License.

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
