# Redaction
Easily redact your ActiveRecord Models.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "redaction"
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
### Redactor Types
`redaction` comes with a few different redactor types:
| Type         | Generates    |
|:------------:|:------------:|
| `:basic`     | A Sentence   |
| `:basic_html`| An HTML snippit with `strong` and `em` tags wrapping some of the words  |
| `:html`      | Multiple HTML Paragraphs with a random amount of link tags, `strong` tags, and `em` tags  |
| `:email`     | A safe (will not send) email address |
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
This will only redcat the `User` and `Post` Models

#### Via the Rails Console
```ruby
Redaction::Redactor.new.redact
```
This will target **all** the models with redacted attributes. To target specific models run:
```ruby
Redaction::Redactor.new(models: ["User", "Post"]).redact
```
This will only redcat the `User` and `Post` Models

## Contributing
Bug reports and pull requests are welcome on GitHub at [drbragg/redaction](https://github.com/drbragg/redaction). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
