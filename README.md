<!--
SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>

SPDX-License-Identifier: MIT
-->

# PVE

`Proxmox` Virtual Environment API client for Elixir.

## Status

Early development. The public API is unstable and the library is not yet
published to Hex. Only `GET /version` is implemented - everything else still
to come.

## Requirements

* Elixir 1.18 or later
* A `Proxmox` VE cluster and an API token

To create a token: **Datacenter -> Permissions -> API Tokens -> Add**. Note
the secret at creation time; it is shown once and cannot be retrieved again.

If **Privilege Separation** is ticked, the token starts with no permissions
regardless of the permissions of the user that owns it. Either untick it, or
grant the token role at `/`.

## Installation

Not yet on Hex. Add it from git:

```elixir
def deps do
  [
    {:pve, github: "w4sp0/ex_proxmox"}
  ]
end
```

`req` is pulled in as the HTTP client.

## Usage

```elixir
{:ok, token} = PVE.Token.new("root", "pam", "automation", "<secret-uuid>")
{:ok, cluster} = PVE.Cluster.new("<your-cluster-ip>", token)

PVE.version(cluster)
#=> {:ok, %{"version" => "8.2.4", "release" => "8.2", "repoid" => "..."}}
```

`PVE.Token.new/4` and `PVE.Cluster.new/3` validate their arguments and return
`{:error, {field, reason}}` identifying the field at fault. The token secret
is redacted from `inspect/1` output, so it does not reach logs or crash dumps.

`PVE.Cluster.new/3` accepts `:port` (default `8006`), `:scheme` (default
`:https`) and `verify_tls` (default `true`).

Keep credentials out of source control. Redad them from the environment
instead:

```elixir
{:ok, token} = PVE.Token.new("root", "pam", "automation", System.fetch_env!("PVE_TOKEN_SECRET"))
```

## TLS

Proxmox ships a self-signed certificate, so verification fails against a stock
cluster. Either install a certificate your system trusts, or disable
verification explicitly:

```elixir
{:ok, cluster} = PVE.Cluster.new("<your-cluster-ip>", token, verify_tls: false)
```

The option is deliberately explicit: disabling certificate verification
exposes the connection to interception, and recording that decision in the
code is better than hiding it in a default.

## Documentation

* [Changelog](CHANGELOG.md)
* [Release procedure](docs/RELEASE.md)

## License

MIT. See [LICENSES/MIT.txt](LICENSES/MIT.txt).

This project follows the [REUSE](https://reuse.software) specification; every
file carries its copyright and license in an SPDX header. To produce the full
bill of materials:

```sh
reuse spdx
```
