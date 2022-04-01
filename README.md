# Redaction
[![Tests](https://github.com/DRBragg/redaction/actions/workflows/ci.yml/badge.svg)](https://github.com/DRBragg/redaction/actions/workflows/ci.yml)

Easily redact your ActiveRecord Models. Great for use when you use production data in staging or dev. Simply set the redaction type of the attributes you want to redact and run via the [console](#via-the-rails-console) or the included [rake task](#via-rake-task).

`redaction` uses [Faker](https://github.com/faker-ruby/faker) under the hood to generate redacted data.

## Installation
**NOTE:** This is currently an unreleased library very much in beta. Use at your own risk.

Add this line to your application's Gemfile:

```ruby
gem "redaction", git: "https://github.com/drbragg/redaction.git"
```

And then execute:
```bash
$ bundle
```

## Usage
### Redacting a Model
To "redact" a models attribute add:
```ruby
class Model < ApplicationRecord
  redacts :<attribute>, with: :<redactor_type>
end
```
`<redactor_type>` can be a symbol, proc, or custom class. See [Redactor Types](#redactor-types) for more information.

`redacts` accepts multiple attributes, provided they all use the same redactor type. i.e.:
```ruby
class User < ApplicationRecord
  redacts :first_name, :last_name, with: :name
end
```
### Redactor Types

#### Built in
`redaction` comes with a few different redactor types:
| Type         | Generates    |
|:------------:|:------------:|
| `:basic`     | A Sentence   |
| `:basic_html`| An HTML snippet with `strong` and `em` tags wrapping some of the words  |
| `:email`     | A safe (will not send) email address |
| `:html`      | Multiple HTML Paragraphs with a random amount of link tags, `strong` tags, and `em` tags  |
| `:name`      | A person first/last name |
| `:text`      | Multiple paragraphs |

To use a built in redactor type set the `with:` option of a `redacts` call to the appropriate symbol.

#### Using a Proc
A Proc `:with` value is given two arguments: the record being redacted, and a hash with the :attribute key-value pair.
```ruby
class Model < ApplicationRecord
  redacts :attribute, with: -> (record, data) { record.id }
end
```
would cause `Model#attribute` to be set to `Model#id` after redaction
#### Using a custom class
Add a folder in `app/`, `redactors/` is suggested, and put custom redactors in there. A custom redactor should inherit from `Redaction::Types::Base` and should define a `content` method. Like so:
```ruby
# app/redactors/custom_redactor.rb
class CustomRedactor < Redaction::Types::Base
  def content
    "Some Custom Value"
  end
end
```
and then to use it:
```ruby
class Model < ApplicationRecord
  redacts :attribute, with: CustomRedactor
end
```
would cause `Model#attribute` to be set to "Some Custom Value" after redaction.
Custom redactor types also get access to the record being redacted via `record`, and a hash with the `:attribute` key-value pair via `data`

### Preforming a Redaction
There are two ways to preform the redaction.

#### Via Rake Task
```bash
rails redaction:redact
```
This will target **all** the models with redacted attributes. To target specific models run:
```bash
rails redaction:redact MODELS=User,Post
```
This will only redact the `User` and `Post` Models

#### Via the Rails Console
```ruby
Redaction::Redactor.new.redact
```
This will target **all** the models with redacted attributes. To target specific models run:
```ruby
Redaction::Redactor.new(models: ["User", "Post"]).redact
```
This will only redact the `User` and `Post` Models

#### Validations and Callbacks
By default, preforming a redaction does not trigger validations or update the `updated_at` attribute.

Callbacks can be skipped with the `:redacting?` method. i.e.:
```ruby
class User < ApplicationRecord
  after_save :do_something, unless: :redacting?

  redacts :first_name, :last_name, with: :name
end
```

## Roadmap
- [ ] Raise Error or at least a message when skipping a passed in Model
- [ ] Configuration (touch, email domains, etc)
- [ ] Better Documentation
- [ ] More types
- [ ] Release v1.0 as a real gem

## Contributing
Bug reports and pull requests are welcome on GitHub at [drbragg/redaction](https://github.com/drbragg/redaction). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/DRBragg/redaction/blob/main/CODE_OF_CONDUCT.md).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgments
`redaction` leans heavily on the awesome [Faker gem](https://github.com/faker-ruby/faker).  If not for their hard work this would be a much different and probably more complex project.  If you like `redaction` please consider sending them a thank you or contributing to the gem.
