# Rails Options

A uniform interface to multiple option YAML files.

As a project's size increases, its credentials file tends to become unmanageable. With Rails Options you can split the credentials into smaller separate YAML files.

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

Create any YAML (`.yml` or `.yaml`) file inside the `config/options` directory. You will find everything in `Rails.application.options`, including the credentials:

```yaml
# config/options/pokemon.yml
pokemon_api:
  base_url: https://pokeapi.co/api/v2
```

```ruby
Rails.application.options
# => {pokemon_api: {base_url: "https://pokeapi.co/api/v2"}}
```

`options` actually returns an `ActiveSupport::OrderedOptions`, which lets you access options as methods, as well as nested hash keys:

```ruby
Rails.application.options.dig(:pokemon_api, :base_url)
Rails.application.options.pokemon_api.base_url
```

The YAML files can be encrypted: if the filename ends in `.enc`, the content will be assumed to have been encrypted with `rails encrypted:edit`. Notice that the command will *not* automatically append the `.enc` extension.

If a filename contains an environment tag, the content will be considered only in the respective environment: `config/options/pokemon.development.yml` will only be loaded in the `development` environment.

Files with the same root name will overwrite each other: environment specific files will overwrite generic ones, and encrypted files will overwrite clear text ones. This way you can provide sensible defaults in the generic files, with encryption if necessary, and override them in specific environments (for example using a `.development` gitignored file to use a local mocked server instead of the real thing). The values are overwritten using `Hash#deep_merge` from Active Support, so you can overwrite only selected values and keep the default for the rest.

Options can also be picked up from environment variables. Any `!env/VAR` YAML tag will be substituted for the value of the `VAR` variable, anywhere in the file (even in keys). For example, setting `VAR=variable`:

```yaml
a_key: !env/VAR
```

will become:

```ruby
{
  a_key: 'variable'
}
```

### Options

You can set these options in `application.rb` or in any of the `environments/*.rb` files.

- `config.options.roots` : the directories, relative to `Rails.root`, in which to look for options files. You can either add to the existing array with `<<` or assign a new array. Default: `['config']`. 
- `config.options.paths` : the patterns (in the format of `Dir.glob`) corresponding to the options files. They will be looked for in all the `roots` directories. Default: `['options.{yml,yaml}{.enc,}', 'options/**/*.{yml,yaml}{.enc,}']`.
- `config.options.raise_on_override` : set this to `true` if you want an exception to be raised if any key would be set by multiple files. If this is `false` and a "conflict" happens, one key will overwrite the other, but the order is undefined. This only applies to files with a different `path/to/file`, not to conflicts between the base and any environment-specific version. Default: `false`.

## Version numbers

Rails Options loosely follows [Semantic Versioning](https://semver.org/), with a hard guarantee that breaking changes to the public API will always coincide with an increase to the `MAJOR` number.

Version numbers are in three parts: `MAJOR.MINOR.PATCH`.

- Breaking changes to the public API increment the `MAJOR`. There may also be changes that would otherwise increase the `MINOR` or the `PATCH`.
- Additions, deprecations, and "big" non breaking changes to the public API increment the `MINOR`. There may also be changes that would otherwise increase the `PATCH`.
- Bug fixes and "small" non breaking changes to the public API increment the `PATCH`.

Notice that any feature deprecated by a minor release can be expected to be removed by the next major release.

## Changelog

Full list of changes in [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moku-io/rails-options.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
