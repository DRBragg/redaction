require "test_helper"
require "rake"

class RedactionTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Redaction::VERSION
  end

  test "it accepts a proc as a redactor" do
    user = users(:one)
    user.redact!

    assert_not_equal "MiddleName", user.middle_name
    assert_equal "User #{user.id}", user.middle_name
  end

  test "it accepts a Class as a redactor" do
    user = users(:one)
    user.redact!

    assert_not_equal "user-name1", user.username
    assert_equal "I'm a custom redactor", user.username
  end

  test "it defaults to '[REDACTED]' when redactor type can't be found" do
    user = users(:one)
    user.redact!

    assert_not_equal "Sr.", user.suffix
    assert_equal "[REDACTED]", user.suffix
  end

  test "it only redacts specified attributes" do
    user = users(:one)
    user.redact!

    assert_not_equal "FirstName", user.first_name
    assert_not_equal "one@example.com", user.email
    assert_equal "LastName", user.last_name
  end

  test "it generates redacted html" do
    post = posts(:one)
    post.redact!

    assert_match(/<p>/, post.body)
    assert_match(/<p>(<[^>]+>)?[A-Z]/, post.body)
    assert_match(/<\/p>/, post.body)
    assert_match(/\w{2,}/, post.body)
  end

  test "it generates redacted basic_html" do
    post = posts(:one)
    post.redact!

    assert_includes post.title, "<strong>"
    assert_includes post.title, "<em>"
  end

  test "it generates redacted email" do
    user = users(:one)
    user.redact!

    assert_match(/example.(com|net|org)/, user.email)
  end

  test "it generates redacted text" do
    comment = comments(:one)
    comment.redact!

    assert_match(/^[A-Z]/, comment.content)
    assert_match(/\n/, comment.content)
    assert_match(/\w{2,}/, comment.content)
    assert_match(/\s/, comment.content)
  end

  test "it generates redacted string" do
    comment = comments(:one)
    comment.redact!

    assert_match(/\w{2,}/, comment.subject)
    assert_match(/\s/, comment.subject)
    assert_no_match(/\.$/, comment.subject)
  end

  test "it generates redacted name" do
    user = users(:one)
    user.redact!

    assert_not_equal "FirstName", user.first_name
    assert user.first_name.scan(/\w+/).length == 1
  end

  test "it skips validation" do
    comment = comments(:one)

    assert comment.subject.length < 10

    comment.redact!

    assert comment.subject.length > 10
    assert comment.persisted?
  end

  test "it allow callbacks to be skipped" do
    comment = comments(:one)

    assert_not_includes comment.subject, "Updated in Callback"
    assert_not_includes comment.content, "Updated in Callback"

    comment.save

    assert_includes comment.reload.subject, "Updated in Callback"
    assert_includes comment.reload.content, "Updated in Callback"

    comment.redact!

    assert_not_includes comment.reload.subject, "Updated in Callback"
    assert_includes comment.reload.content, "Updated in Callback"
  end

  test "it redacts all redactable models" do
    comment = comments(:one)
    user = users(:one)
    post = posts(:one)

    Redaction.redact!

    assert_not_equal comment.content, comment.reload.content
    assert_not_equal user.email, user.reload.email
    assert_not_equal post.body, post.reload.body
  end

  test "it can target specific models" do
    comment = comments(:one)
    user = users(:one)
    post = posts(:one)

    Redaction.redact!(models: ["Comment", "User"])

    assert_not_equal comment.content, comment.reload.content
    assert_not_equal user.email, user.reload.email
    assert_equal post.body, post.reload.body
  end

  test "it has a rake task" do
    Rails.application.load_tasks

    assert_includes Rake::Task.tasks.map(&:name), "redaction:redact"
  end

  test "it has a rake task to all redactable models" do
    Rails.application.load_tasks

    comment = comments(:one)
    user = users(:one)
    post = posts(:one)

    ENV["MODELS"] = ""
    Rake::Task["redaction:redact"].invoke

    assert_not_equal comment.content, comment.reload.content
    assert_not_equal user.email, user.reload.email
    assert_not_equal post.body, post.reload.body
  end

  test "it has a rake task that can target specific models" do
    Rails.application.load_tasks

    comment = comments(:one)
    user = users(:one)
    post = posts(:one)

    ENV["MODELS"] = "Comment,User"
    Rake::Task["redaction:redact"].execute

    assert_not_equal comment.content, comment.reload.content
    assert_not_equal user.email, user.reload.email
    assert_equal post.body, post.reload.body
  end

  test "it works with attr_encrypted" do
    user = users(:one)
    user.update(ssn: "111-11-1111")
    user.redact!

    assert_not_equal "111-11-1111", user.ssn
  end

  test "it works with lockbox" do
    user = users(:one)
    user.update(phone: "(111) 111-1111")
    user.redact!

    assert_not_equal "(111) 111-1111", user.phone
  end

  test "it generates a redacted phone number" do
    account = accounts(:one)
    account.redact!

    assert_not_equal "(111) 111-1111", account.phone_number
    assert_match(/\d?.?\(?\d{3}\)?\s?.?\d{3}.?\d{4}/, account.phone_number)
  end

  test "it generates a redacted email with a specific domain if configured" do
    Redaction.config.email_domain = "special.com"

    user = users(:one)
    user.redact!

    Redaction.config.email_domain = nil # Reset

    assert_match(/special.com$/, user.email)
  end

  test "it raises an error if redaction is attempted in production" do
    Rails.stub(:env, "production".inquiry) do
      assert_raises(Redaction::ProductionEnvironmentError) do
        Redaction.redact!
      end
    end
  end

  test "it raises an error if redaction is attempted on a model in production" do
    post = posts(:one)

    Rails.stub(:env, "production".inquiry) do
      assert_raises(Redaction::ProductionEnvironmentError) do
        post.redact!
      end

      assert_equal post.body, post.reload.body
    end
  end

  test "it aborts the rake task if it is attempted in production" do
    Rails.application.load_tasks

    Rails.stub(:env, "production".inquiry) do
      assert_raises(SystemExit) do
        Rake::Task["redaction:redact"].execute
      end
    end
  end

  test "it doesn't redact data if in production" do
    Rails.stub(:env, "production".inquiry) do
      post = posts(:one)

      begin
        Redaction.redact!
      rescue Redaction::ProductionEnvironmentError
      end

      assert_equal post.body, post.reload.body
    end
  end

  test "it skips the progress bar if configured" do
    Redaction.config.progress_bar = false

    out, _err = capture_subprocess_io do
      Redaction.redact!
    end

    assert_equal "", out

    Redaction.config.progress_bar = true # Reset
  end

  test "has a progress bar by default" do
    out, _err = capture_subprocess_io do
      Redaction.redact!
    end

    assert_not_equal "", out
  end

  test "it generates redacted content even if the attribute is empty if configured" do
    Redaction.config.force_redaction = true

    user = users(:one)
    user.update(email: nil)
    user.redact!

    Redaction.config.force_redaction = false # Reset

    assert_not_nil user.email
    assert_match(/@/, user.email)
  end
end
