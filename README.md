Brainfuck interpreter written in dartlang.

## HOW TO

### Setting GitHub Pages content.

 - Running shell commands.

```shell
$ pub build
$ cd build/web
$ git init
$ git add .
$ git commit -m <commit-msg, such as "Update Github Pages content.">
$ git remote origin <origin-url, such as "git@github.com:joojis/bf_interpreter.dart.git">
$ git push -f origin HEAD:gh-pages
```

 - Check website "https://\<username\>.github.io/\<project_name\>"

### Running BF file (Currently not supported)

```shell
$ dart bin/cli.dart <BF filepath>
```
