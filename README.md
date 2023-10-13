# Rails Options

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-options', '~> 1.0'
```

And then execute:

```bash
$ bundle
```

## Usage

Add YAML (`.yml` or `.yaml`) files inside the `config/options` directory, and/or a `config/options.yml` file. In `Rails.application.options` you will find all the options collected from all the files, including the credentials.

Any value (or key) that is tagged with `!env/VARIABLE_NAME` will be substituted with the value of the `VARIABLE_NAME` environment variable. The value provided in the YAML file, if any, will be dropped. For example, setting `VAR="variable"`:

```yaml
a_key: !env/VAR
```

will become:

```ruby
{
  a_key: 'variable'
}
```

The file name can have this format:

`path/to/file.<environment>.<format>.enc`

- `<environment>` is optional. If two files have the same `path/to/file`, then the one without environment will be considered as "base" and will be overridden by the one with an environment that matches `Rails.env`. Notice that only `path/to/file` is considered for this override. In particular, a file can be encrypted and still "match".
- `<format>` can be either `.yml` or `.yaml`.
- `enc` is optional. If it is present, the file is decrypted on the fly.


You can create encrypted files using

```bash
rails encrypted:edit full/path/to/file.yml.enc
```

(notice that you need to explicitly add `.enc`).

### Options

You can set these options in `application.rb` or in any of the `environments/*.rb` files.

- `config.options.roots` : the directories in which to look for options files. You can either add to the existing array with `<<` or assign a new array. Default: `['config']`. 
- `config.options.paths` : the `Dir.glob` patterns corresponding to the options files. They will be looked for in all the `roots` directories. Default: `['options.{yml,yaml}{.enc,}', 'options/**/*.{yml,yaml}{.enc,}']`.
- `config.options.raise_on_override` : set this to `true` if you want an exception to be raised if any key would be set by multiple files. If this is `false` and a "conflict" happens, the behavior is undefined. Default: `false`.
