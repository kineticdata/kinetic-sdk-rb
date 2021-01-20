# Change Log

## [5.0.15](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.15) (2021-01-20)

**Implemented enhancements:**

- Bug Fixes

## [5.0.14](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.14) (2021-01-15)

**Implemented enhancements:**

- Support for submitting attachments (datastore and form submissions)
- Bug Fixes

## [5.0.13](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.13) (2020-09-03)

**Implemented enhancements:**

- Added missing Form Type methods.
- Deprecated some Form Type methods and replaced with simpler names.
- Removed an unnecessary logging statement when adding a team attribute.
- Removed double URL encoding when deleting a webhook from a Kapp.

## [5.0.12](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.12) (2020-08-27)

**Implemented enhancements:**

- Implemented webapi APIs

## [5.0.11](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.11) (2020-08-24)

**Implemented enhancements:**

- Allow spaces in filenames when exporting items. Spaces were removed in 5.0.10, but they are valid in Windows so allowing them if they exist.

## [5.0.10](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.10) (2020-08-24)

**Implemented enhancements:**

- Changed how filenames are stored when items are exported to be compatible with Windows.

## [5.0.9](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.9) (2020-06-29)

**Implemented enhancements:**

- Bug fixes

## [5.0.8](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.8) (2020-06-11)

**Implemented enhancements:**

- Bug fixes

## [5.0.7](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.7) (2020-05-15)

**Implemented enhancements:**

- Bug fixes

## [5.0.6](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.6) (2020-04-24)

**Implemented enhancements:**

- Bug fixes

## [5.0.5](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/5.0.5) (2020-04-24)

**Implemented enhancements:**

- Bug fixes

## [5.0.4](https://github.com/kineticdata/kinetic-sdk-rb/tree/5.0.4) (2020-02-12)

**Implemented enhancements:**

- Implemented platform components APIs

## [5.0.3](https://github.com/kineticdata/kinetic-sdk-rb/tree/5.0.3) (2020-01-17)

**Implemented enhancements:**

- Implemented task engine configuration APIs

## [5.0.2](https://github.com/kineticdata/kinetic-sdk-rb/tree/5.0.2) (2020-01-10)

**Implemented enhancements:**

- Fixed bug with jetching JWT regarding redirects

## [5.0.1](https://github.com/kineticdata/kinetic-sdk-rb/tree/5.0.1) (2020-01-10)

**Implemented enhancements:**

- Implemented Task System error API
- Fixed typo in Discussions component

## [5.0.0](https://github.com/kineticdata/kinetic-sdk-rb/tree/5.0.0) (2019-12-19)

### **1.x to 5.x Upgrade Warning**

All platform components (Core, Task, Agent, Discussions...etc) should be running a 5.x release or greater.
Unintended behavior is possible if running 5.x of the SDK against any platform component < 5.x.

## [1.0.2](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/1.0.2) (2019-12-18)

**Implemented enhancements:**

- Bug fixes

## [1.0.1](https://github.com/kineticdata/kinetic-sdk-rb/releases/tag/1.0.1) (2019-12-17)

**Implemented enhancements:**

- Bug fixes

## [1.0.0](https://github.com/kineticdata/kinetic-sdk-rb/tree/1.0.0) (2019-06-13)

### **0.x to 1.x Upgrade Warning**

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
