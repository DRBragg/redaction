require "test_helper"
require "rake"

class RedactionTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Redaction::VERSION
  end

  test "it only redacts specified attributes" do
    user = users(:one)
    user.redact!

    assert_not_equal user.first_name, "FirstName"
    assert_not_equal user.email, "one@example.com"
    assert_equal user.last_name, "LastName"
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

    assert_not_equal user.first_name, "FirstName"
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

    Redaction::Redactor.new.redact

    assert_not_equal comment.content, comment.reload.content
    assert_not_equal user.email, user.reload.email
    assert_not_equal post.body, post.reload.body
  end

  test "it can target specific models" do
    comment = comments(:one)
    user = users(:one)
    post = posts(:one)

    Redaction::Redactor.new(models: ["Comment", "User"]).redact

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

    assert_not_equal user.ssn, "111-11-1111"
  end

  test "it works with lockbox" do
    user = users(:one)
    user.update(phone: "(111) 111-1111")
    user.redact!

    assert_not_equal user.phone, "(111) 111-1111"
  end
end
