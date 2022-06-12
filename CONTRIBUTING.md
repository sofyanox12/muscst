# Contributing to muscst

Thank you for your interest in contributing to `muscst`! This project brings native window exclusion capabilities to GNOME Mutter on Wayland.

## Maintainer

- **Sofyan Pujas** ([@sofyanox12](https://github.com/sofyanox12))

## Code of Conduct

Please maintain a constructive, respectful, and collaborative environment.

## Development Workflow

1. **Fork and Clone**:
   ```bash
   git clone https://github.com/sofyanox12/muscst.git
   cd muscst
   ```

2. **Branching**:
   Create a dedicated feature branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Coding Standards**:
   - **Mutter C Patch (`patches/*.patch`)**:
     - Adhere strictly to the [GNOME / Mutter C Coding Style](https://gitlab.gnome.org/GNOME/mutter/-/blob/main/doc/coding-style.txt).
     - 2-space indentation, no tabs.
     - Function calls: space before parentheses (`function_name (arg)`).
     - GNU/Allman braces on a new line.
     - Zero memory leaks and zero synchronous blocking allocations in hot render paths.
   - **Python Controller (`bin/muscst`)**:
     - Follow PEP 8 style guidelines.
     - Limit logic nesting to a maximum of 3 levels.
     - Strict type annotations for function parameters and return values.
     - Avoid redundant inline comments that restate the code.
   - All documentation and commit messages must be written in clear English.

4. **Testing Changes**:
   - Verify Python CLI syntax and interface:
     ```bash
     python3 -m py_compile bin/muscst
     ./bin/muscst --help
     ```
   - Audit PKGBUILD packaging metadata:
     ```bash
     namcap PKGBUILD
     makepkg --printsrcinfo > .SRCINFO
     ```

5. **Submitting Pull Requests**:
   - Provide a clear explanation of the problem solved.
   - Include compatibility notes for the target Mutter version.
