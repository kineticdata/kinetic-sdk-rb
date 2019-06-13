# Change Log

## [1.0.0](https://github.com/kineticdata/kinetic-sdk-rb/tree/1.0.0) (2019-06-13)

** 0.x to 1.x Upgrade Warning **

Export methods have been updated to reflect the folder structure
of their respective API routes.

For Example: in the 0.x versions of the SDK, the `export_trees` method would
place the exported trees inside export_directory/trees. Starting in version 1.0.0, trees are exported to export_directory/sources/:source-name/trees

**Implemented enhancements:**

- Ability to export a space in one step using the `export_space` method.
