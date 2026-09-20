<!--
SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>

SPDX-License-Identifier: MIT
-->

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com), and
this project adheres to [Semantic Versioning](https://semver.org).

## [Unreleased]

### Added
- `PVE.Token` struct holding the four parts of a Proxmox API token credential,
  with `new/4` validating each field and `to_header/1` assembling the
  `PVEAPIToken` authorisation header.
- `PVE.Cluster` connection descriptor holding host, port, scheme, TLS
  verification and a token, with `new/3` applying defaults and validating each
  field, and `base_url/1` returning the `/api2/json` root.
- `PVE.Request.new/1`, building a configured `Req` request from a cluster and
  mapping `verify_tls` onto the transport options.
- `PVE.version/1`, issuing `GET /version` as a connectivity check and
  unwrapping the Proxmox `data` envelope.
- Release procedure in `docs/RELEASE.md`.
- REUSE 3.3 compliance: SPDX headers on all files, `LICENSES/MIT.txt` and
  `REUSE.toml`.

### Changed

- Minimum Elixir version is now 1.18.

### Security

- The token secret is redacted from `inspect/1` output via `@derive {Inspect,
  except: [:secret]}`, keeping it out of logs, crash dumps and test failure
  diffs.

[Unreleased]: https://github.com/w4sp0/ex_proxmox/commits/main
