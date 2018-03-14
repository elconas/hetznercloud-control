# Running inspec tests

## Run via Docker with SSH Agent Auth

```
shell$ docker pull chef/inspec
shell$ function inspec { docker run -it --rm -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v $(pwd):/share chef/inspec $@; }
shell$ inspec exec test/inspec/role/hetznerserver -t ssh://root@IP_OF_SERVER
```

## Links

 - https://inspec.io
 - https://dev-sec.io
