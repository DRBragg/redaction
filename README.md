# Redaction
Easily redact your ActiveRecord Models. Great for use when you use production data in staging or dev. Simply set the redaction type of the attributes you want to redact and run via the [console](#via-the-rails-console) or the included [rake task](#via-rake-task).

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
`redacts` accepts multiple attributes, provided they all use the same redactor type. i.e.:
```ruby
class User < ApplicationRecord
  redacts :first_name, :last_name, with: :name
end
```
### Redactor Types
`redaction` comes with a few different redactor types:
| Type         | Generates    |
|:------------:|:------------:|
| `:basic`     | A Sentence   |
| `:basic_html`| An HTML snippit with `strong` and `em` tags wrapping some of the words  |
| `:email`     | A safe (will not send) email address |
| `:html`      | Multiple HTML Paragraphs with a random amount of link tags, `strong` tags, and `em` tags  |
| `:name`      | A person first/last name |
| `:text`      | Multiple paragraphs |

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

## Contributing
Bug reports and pull requests are welcome on GitHub at [drbragg/redaction](https://github.com/drbragg/redaction). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/DRBragg/redaction/blob/main/CODE_OF_CONDUCT.md).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
