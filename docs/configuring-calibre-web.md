<!--
SPDX-FileCopyrightText: 2020 - 2024 MDAD project contributors
SPDX-FileCopyrightText: 2020 - 2024 Slavi Pantaleev
SPDX-FileCopyrightText: 2020 Aaron Raimist
SPDX-FileCopyrightText: 2020 Chris van Dijk
SPDX-FileCopyrightText: 2020 Dominik Zajac
SPDX-FileCopyrightText: 2020 Mickaël Cornière
SPDX-FileCopyrightText: 2022 François Darveau
SPDX-FileCopyrightText: 2022 Julian Foad
SPDX-FileCopyrightText: 2022 Warren Bailey
SPDX-FileCopyrightText: 2023 Antonis Christofides
SPDX-FileCopyrightText: 2023 Felix Stupp
SPDX-FileCopyrightText: 2023 Pierre 'McFly' Marty
SPDX-FileCopyrightText: 2024 noah
SPDX-FileCopyrightText: 2024 - 2025 Suguru Hirahara

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Setting up Calibre-Web

This is an [Ansible](https://www.ansible.com/) role which installs [Calibre-Web](https://github.com/janeczku/calibre-web) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

Calibre-Web is a web app that offers a clean and intuitive interface for browsing, reading, and downloading eBooks using a valid [Calibre](https://calibre-ebook.com/) database.

See the project's [documentation](https://github.com/janeczku/calibre-web/wiki) to learn what Calibre-Web does and why it might be useful to you.

## Adjusting the playbook configuration

To enable Calibre-Web with this role, add the following configuration to your `vars.yml` file.

**Note**: the path should be something like `inventory/host_vars/mash.example.com/vars.yml` if you use the [MASH Ansible playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).

```yaml
########################################################################
#                                                                      #
# calibre_web                                                          #
#                                                                      #
########################################################################

calibre_web_enabled: true

########################################################################
#                                                                      #
# /calibre_web                                                         #
#                                                                      #
########################################################################
```

### Set the hostname

To enable the Calibre-Web instance you need to set the hostname as well. To do so, add the following configuration to your `vars.yml` file. Make sure to replace `example.com` with your own value.

```yaml
calibre_web_hostname: "example.com"
```

After adjusting the hostname, make sure to adjust your DNS records to point the domain to your server.

### Mount a directory for loading Calibre database (optional)

By default, Calibre-Web will search `/books` directory for your Calibre database.

You can mount a directory so that the instance loads the database. To mount it, prepare a local directory on the host machine and add the following configuration to your `vars.yml` file:

```yaml
calibre_web_books_path: /path/on/the/host
```

Make sure permissions and owner of the directory specified to `calibre_web_books_path`.

### Enable ebook conversion binary (optional)

You can add the Calibre ebook-convert binary (x64 only) by adding the following configuration to your `vars.yml` file:

```yaml
calibre_web_environment_variables_conversion_ability_enabled: true
```

The path to the binary is `/usr/bin/ebook-convert`. It needs to be specified in the web interface — as well as the path to Calibre binaries (`usr/bin`).

### Extending the configuration

There are some additional things you may wish to configure about the service.

Take a look at:

- [`defaults/main.yml`](../defaults/main.yml) for some variables that you can customize via your `vars.yml` file. You can override settings (even those that don't have dedicated playbook variables) using the `calibre_web_environment_variables_additional_variables` variable

## Installing

After configuring the playbook, run the installation command of your playbook as below:

```sh
ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start
```

If you use the MASH playbook, the shortcut commands with the [`just` program](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/just.md) are also available: `just install-all` or `just setup-all`

## Usage

After running the command for installation, Calibre-Web becomes available at the specified hostname with `calibre_web_hostname` and `calibre_web_path_prefix` like `https://example.com/calibre-web`.

You can log in to the instance with the default login credential of the admin account (username: `admin`, password: `admin123`).

On the initial configuration screen, enter `/books` as your Calibre library location.

After setting up the database configuration, **make sure to change the login credential** at `https://example.com/calibre-web/admin/view`.

## Troubleshooting

### Check the service's logs

You can find the logs in [systemd-journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html) by logging in to the server with SSH and running `journalctl -fu calibre-web` (or how you/your playbook named the service, e.g. `mash-calibre-web`).
