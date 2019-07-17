# Change Log

## [1.0.0](https://github.com/kineticdata/kinetic-sdk-rb/tree/1.0.0) (2019-06-13)

** 0.x to 1.x Upgrade Warning **

Export methods have been updated to reflect the folder structure
of their respective API routes.

For Example: in the 0.x versions of the SDK, the `export_trees` method would
place the exported trees inside export_directory/trees. Starting in version 1.0.0, trees are exported to export_directory/sources/:source-name/trees

The logger was changed from the `KineticSdk::Utils::Logger` module to the `KineticSdk::Utils::KLogger` class. This shouldn't have any effect on external scripts unless referencing the kinetic logger directly, which is unlikely. If that is the case however, you will need to update your scripts to reference the `logger` SDK variable instead of the static `KineticSDK::Utils::Logger` module.

```ruby
# 0.x example of logging in a script:
sdk = KineticSdk::Core.new({
  app_server_url: "http://localhost:8080/kinetic",
  space_slug: "foo",
  username: "space-user-1",
  password: "password"
})
KineticSdk::Utils::Logger.info("foo")


# 1.0 example of logging in a script
sdk = KineticSdk::Core.new({
  app_server_url: "http://localhost:8080/kinetic",
  space_slug: "foo",
  username: "space-user-1",
  password: "password"
})
sdk.logger.info("foo")
```

**Implemented enhancements:**

- Ability to export a space in one step using the `export_space` method.
- Gateway errors (HTTP codes [502](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/502), [503](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/503), and [504](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/504)) will automatically be retried, and may be controlled by the following options:
  - :gateway_retry_limit (default 5), set to -1 to disable retrying gateway errors
  - :gateway_retry_delay (default 1.0)
