# Azure Infrastructure Documentation

## Documentation Structure
This directory contains comprehensive documentation for our Azure Infrastructure as Code project.

### Directory Layout

```
docs/
├── architecture/                    # Infrastructure architecture documentation
│   ├── high-level-design.md        # Overall system design and principles
│   └── network-topology.md         # Network architecture and configuration
│
├── runbooks/                       # Operational guides and procedures
│   ├── deployment.md               # Step-by-step deployment instructions
│   ├── disaster-recovery.md        # DR procedures and recovery steps
│   └── maintenance.md              # Regular maintenance procedures
│
├── procedures/                     # Process-specific documentation
│   ├── github-secrets.md           # GitHub secrets configuration guide
│   └── cicd-workflow.md            # CI/CD pipeline documentation
│
└── module-usage/                   # Module implementation guides
    ├── networking.md               # Networking module usage
    ├── security.md                 # Security module usage
    ├── compute.md                  # Compute module usage
    └── storage.md                  # Storage module usage
```

## Getting Started
1. Start with [high-level-design.md](architecture/high-level-design.md) for system overview
2. Review [network-topology.md](architecture/network-topology.md) for network design
3. Follow [deployment.md](runbooks/deployment.md) for implementation steps

## Documentation Updates
- Keep documentation up to date with infrastructure changes
- Follow the existing format when adding new content
- Include practical examples where possible
- Verify all links and references

## Best Practices
1. Read relevant documentation before making changes
2. Follow runbooks for standard procedures
3. Refer to module usage guides for implementation
4. Consult disaster recovery procedures when needed