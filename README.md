Ruby environment for Vagrant
============================

Environment
-----------

- CentOS 7
- Ruby with rbenv
- Node.js (for Rails, execjs)
- nginx
- PostgreSQL
- Redis
- and some useful utilities (tig, screen, tmux, direnv, ...)

See `provisioner.sh` for more details.

Prerequirements
---------------

- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) (vagrant plugin)

Install `vagrant-vbguest` plugin.

```
vagrant plugin install vagrant-vbguest
```

How to use
----------

1. Clone this repository.
2. Run `vagrant up`.
