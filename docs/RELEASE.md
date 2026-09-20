<!--
SPDX-FileCopyrightText: 2026 Radek Janik <cyberwassp@gmail.com>

SPDX-License-Identifier: MIT
-->

# Release

PVE release procedure.

## Table of Contents
*   [Versioning](#versioning)
*   [Prerequisites](#prerequisites)
*   [Signing](#signing)
*   [Procedure](#procedure)
*   [Verification](#verification)
*   [CI guard](#ci-guard)
*   [Withdrawing a release](#withdrawing-a-release)

## Versioning

The project follows [semantic versioning](https://semver.org). Hex resolves
dependencies by those rules, so the version is a contract, not a label.

`@version` in `mix.exs` is the single source of truth. The git tag, the Hex
package, the generated documentation and `docs.source_ref` all derive from it.

While the library is in `0.x`, no compatibility is promised: breaking changes
bump the minor, not the major. Cut `1.0.0` only once the request pipeline is
settled, because that is the release where the promise begins.

Tags are named `v<version>`, for example `v0.1.0`. The `v` prefix is required:
`docs.source_ref: "v#{@version}"` builds ExDocs's source links from it, and
they resolve to 404 if the tag is named otherwise.

## Prerequisites

One-time setup, before the first release:
* a GPG key, with git configured to use it:

```sh
git config commit.gpgsign true
git config tag.gpgsign true
```

* Hex authentication: `mix hex.user auth`.
* `package: package()` wired into `project/0` in `mix.exs`. Without it the
  licence metadata is absent and `mix hex.publish` refuses.
* `CHANGELOG.md` in [Keep a Changelog](https://keepachangelog.com) format,
  with an `Unreleased` section at the top.

## Signing

Commits are signed when they are made, and release tags are signed with `git
tag -s`. Verification is then a single command:

```sh
git verify-commit HEAD
git verify-tag v0.1.0
```

Signing commits at creation avoids the alternative pattern of tagging an
unsigned commit afterwards to vouch for it.

## Procedure

1. Confirm the working tree is clean and the suite is green:

```sh
git status --short
mix format --check-formatted
mix test
```

2. Bump `@version` in `mix.exs`.
3. In `CHANGELOG.md`, move the `Unreleased` entries into a new section headed
   with the version and the release date.
4. Commit both files together:

```sh
git commit -S -am "Release v0.1.0"
```

5. Tag the release commit:

```sh
git tag -s v0.1.0 -m "v0.1.0"
```

6. Push the commit and the tag in one step:

```sh
git push origin main --follow-tags
```

`--follow-tags` pushes annotated tags alongside the commits, so the release
cannot be pushed without its tag.

7. Publish to Hex:

```sh
mix hex.publish
```

Review the file list it prints before confirming. It is governed by
`package.files` in `mix.exs`.

8. Create `GitHub` release from the tag:

```sh
gh release create v0.1.0 --notes-from-tag
```

## Verification

After publishing:

```sh
git verify-tag v0.1.0
mix hex.info pve
```

Check that the documentation renders and that its source links resolve to the
tagged commit rather than 404.

## CI guard

The most common release defect is a tag that disagrees with `@version`. A job
triggerd on `v*` tags should fail when they diverge:

```sh
tag="${GITHUB_REF_NAME#v}"
version="$(mix run --no-start -e 'IO.puts(Mix.Project.config()[:version])')"
test "${tag}" = "${version}" ||
    { printf '%s\n' "Tag ${tag} does not match mix.exs version ${version}"
    >&2; exit 1; }
```

Publishing itself is done locally rather than from CI. Automating it would
require a Hex API key in repository secrets; for a single maintainer that is a
credential to guard with no workflow gain.

## Withdrawing a release

A published version cannot be deleted once other projects can depend on it.
Immediately after publishing, while Hex still permits it:

```sh
mix hex.publish --revert 0.1.0
```

Later, mark it unusable without removing it, so existing dependents keep
resolving:

```sh
mix hex.retire pve 0.1.0 invalid --message "Reason for retirement"
```

Never republish different content under a version that has already been
released. Publish a new patch version instead.
