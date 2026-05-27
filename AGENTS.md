# AGENTS Guide

This file explains how coding agents should work in this repository.

## General

### Approach

- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.

### Output

- Return code first. Explanation after, only if non-obvious.
- No inline prose. Use comments sparingly - only where logic is unclear.
- No boilerplate unless explicitly requested.

### Code Rules

- Simplest working solution. No over-engineering.
- No abstractions for single-use operations.
- No speculative features or "you might also want..."
- Read the file before modifying it. Never edit blind.
- No docstrings or type annotations on code not being changed.
- No error handling for scenarios that cannot happen.
- Three similar lines is better than a premature abstraction.

### Review Rules

- State the bug. Show the fix. Stop.
- No suggestions beyond the scope of the review.
- No compliments on the code before or after the review.

### Debugging Rules

- Never speculate about a bug without reading the relevant code first.
- State what you found, where, and the fix. One pass.
- If cause is unclear: say so. Do not guess.

### Simple Formatting

- No em dashes, smart quotes, or decorative Unicode symbols.
- Plain hyphens and straight quotes only.
- Natural language characters (accented letters, CJK, etc.) are fine when the content requires them.
- Code output must be copy-paste safe.

## Project Overview

The url-redirect project is a lightweight, nginx-based HTTP redirect service. It's a simple, production-ready containerized application with minimal dependencies.

## Key Principles

### 1. Minimal Changes

- Keep modifications focused and minimal
- Avoid unnecessary refactoring or structure changes
- Maintain the simplicity that makes this project valuable

### 2. Container-First Approach

- All changes should be compatible with containerized deployment
- Test changes using Docker: `docker build -t url-redirect . && docker run -p 8080:8080 -e REDIRECT_URL=https://example.com url-redirect`
- Ensure the entrypoint.sh and Dockerfile remain the primary deployment mechanism

### 3. Configuration Management

- All runtime configuration should flow through environment variables
- The `entrypoint.sh` script is the entry point for configuration
- Use `nginx.conf.template` for templating, not hardcoded values

### 4. Security First

- Keep security headers enabled unless explicitly removing them is justified
- No cleartext sensitive data in logs or output
- Use minimal base images (Alpine Linux)
- Verify the Docker image digest when updating the base image

## Common Tasks

### Adding Features

1. **Simple configuration changes**: Modify `nginx.conf.template` and document in README.md
2. **New environment variables**:
   - Add to `entrypoint.sh` with error checking
   - Document in README.md
   - Update docker run examples
3. **New endpoints**: Add location blocks to `nginx.conf.template`

### Testing Changes

```bash
# Build locally
docker build -t url-redirect .

# Test with environment variables
docker run -p 8080:8080 -e REDIRECT_URL=https://example.com url-redirect

# Verify health check
curl http://localhost:8080/_health

# Verify redirect
curl -i http://localhost:8080/test
```

### Documentation Updates

- Keep README.md synchronized with actual behavior
- Document all environment variables
- Include examples for common use cases
- Note any breaking changes clearly

## Areas of Responsibility

### entrypoint.sh

- Validate required environment variables
- Configure nginx dynamically
- Handle errors gracefully
- Keep it simple and POSIX-compliant

### nginx.conf.template

- Define server configuration
- Set security headers
- Configure timeouts appropriately
- Use `${VARIABLE}` syntax for environment variable substitution

### Dockerfile

- Use specific base image digests for reproducibility
- Keep image size minimal
- Ensure proper file permissions
- Expose only necessary ports

### README.md

- Provide clear, concise documentation
- Include practical examples
- Document all configuration options
- Explain security features

## Code Style

- Shell scripts: POSIX-compliant, with error handling (`set -e`)
- Nginx config: Follow standard formatting conventions
- No trailing whitespace
- Consistent indentation (2 spaces for YAML/templates)

## Version Management

- Nginx image: Keep up-to-date with security patches, but test carefully
- Base image: Use specific digest pins for reproducibility
- Dependencies: Minimal; track any additions carefully

## Deployment Considerations

- The service is stateless and horizontally scalable
- Single-port deployment (8080)
- No persistent storage required
- Health checks should be monitored externally

## When to Ask for Clarification

- Uncertainty about security implications
- Changes that would increase image size significantly
- Modifications that affect the core redirect logic
- Breaking changes to environment variable names or behavior
