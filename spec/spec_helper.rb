$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "kinetic_sdk"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.disable_monkey_patching!
  config.order = :random
end

module SpecHelpers
  # Absolute path to the fixture export directory used by the task import specs.
  def fixture_export_directory
    File.expand_path("fixtures/export", __dir__)
  end

  # A Task SDK instance that performs no network calls on construction.
  def task_sdk(export_directory: fixture_export_directory)
    KineticSdk::Task.new(
      app_server_url: "http://localhost:8080/kinetic-task",
      username: "test-user",
      password: "test-password",
      options: {
        export_directory: export_directory,
        log_level: "off",
      },
    )
  end
end

RSpec.configure { |config| config.include SpecHelpers }
