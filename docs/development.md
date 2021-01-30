# Development
During development you can use a local copy of the engine in your app and there
are 2 options for doing this.

### Option 1

In the main app, package.json file, replace:

```
"slickr_cms": "git+https://github.com/primate-inc/slickr#master"
```

with a local copy like

```
"slickr_cms": "file:/Users/primate/Documents/Projects/slickr"
```

and use the local copy of the engine to load into the main apps node_modules.
This works well if you need to make changes to the codebase that does not
involve the webpacker code.

### Option 2

To live reload your changes on the local engine rather than loading a compiled
version into the main app you can run the following from the engine:

```bash
yarn install
```

to install any missing packages. Then

```bash
yarn link
```

Now in your main app type

```bash
yarn link slickr_cms
```

To make sure your local version is compiled, you should add its path to `config/webpacker.yml`

```yml
resolved_paths: ['../slickr']
```

The local engine now takes precedence over the version in the main app node_modules
folder and when you run the dev server in the main app with

```bash
./bin/webpack-dev-server
```

any changes you make to your engine react code will be live reloaded.

When you're done you can type

```bash
yarn unlink slickr_cms
```

from the main app but note that you'll have to ``` yarn install ``` again as the
slickr_cms node module will be removed.




to bundle non-js files you have to use this line of code in the other programs Gemfile:
```bash
    gem "slickr_cms", :path => "/Users/<user-name>/slickr"
```
