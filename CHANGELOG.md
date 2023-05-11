## [0.13.1] - 2023-05-11

* Fixed `onSubmitted` behavior and public State classes (#86)

## [0.13.0] - 2023-02-26

* Upgrade to Flutter 3.7
* Fix `deprecated_member_use`
* Fix active icon color

## [0.12.0] - 2022-12-28

* Call `onSubmitted` when step buttons are pressed

## [0.11.0] - 2022-11-05

* Add `onSubmitted`

## [0.10.0] - 2022-09-24

* Add `pageStep`
* Add `iconSize`
* Fix icon color after losing focus

## [0.9.0] - 2022-04-24

* BREAKING CHANGES:
  - It is no longer possible to set `prefixText` or `suffixText`. Use `prefix`
    and `suffix` widgets, instead.
  - The decoration defaults to an outline border. Use `border` to change the
    decoration.

* Fix arrow key handling in Flutter 2.10+
* Fix decoration label alignment by setting `prefix` and `suffix` instead of
  `prefixIcon` and `suffixIcon`. (thanks @doppio)
* Default to outline border decoration to gain more sensible looks out of the
  box, unless _any_ border is already specified.
* Add `digits` property. (thanks @akhokhlushin)
* Clean up focus change listeners.

## [0.8.0] - 2021-12-20

* Exposed focusNode (thanks @leonardo2204!)

## [0.7.0] - 2021-11-13

* Introduce SpinBoxTheme and SpinBoxThemeData
* Add SpinBox.iconColor and SpinBoxThemeData.iconColor
* Add SpinBoxThemeData.decoration (NOTE: SpinBox.decoration is now nullable)

## [0.6.0] - 2021-08-27

* Add readOnly property (thanks @brasizza!)

## [0.5.4] - 2021-08-13

* Another value update fix

## [0.5.3] - 2021-08-13

* Fix value updates on widget rebuild

## [0.5.2] - 2021-04-29

* Fix canChange callback

## [0.5.1] - 2021-04-28

* Fix compatibility with latest Flutter master (thanks @wayneprice!)

## [0.5.0] - 2021-04-26

* Add canChange, beforeChange, and afterChange callbacks (thanks @daybson!)

## [0.4.1] - 2021-04-18

* Add `showButtons` property

## [0.4.0] - 2021-03-15

* Stable null-safe version with stable SDK constraints
* Upgraded depencencies
* Fixed ripple effects to show above the text field

## [0.4.0-nullsafety.0] - 2021-01-01

* Migrated to null safety
* Happy New Year!

## [0.3.1+2] - 2020-12-31

* Cleaned up an unused intl package dependency and import.

## [0.3.1+1] - 2020-12-31

* Fixed package revision/contents.

## [0.3.1] - 2020-12-31

* Made input validation less strict to avoid situations where a entering
  an intermediate value that was less than the minimum value would not be
  allowed. The input is fixed up when the value is submitted or the input
  focus is lost.

## [0.3.0] - 2020-12-10

* Added (Cupertino)SpinBox.cursorColor property

## [0.2.3] - 2020-12-09

* Fixed text to update on focus change (Thanks again @vannevar-morgan!)

## [0.2.2] - 2020-12-09

* Fixed a bug that allowed entering "" and "-". (Thanks @vannevar-morgan!)

## [0.2.1] - 2020-10-09

* Updated the cupertino_icons dependency to version 1.0.0.

## [0.2.0] - 2020-05-30

* Introduced CupertinoSpinBox.

## [0.1.0] - 2020-05-19

* Initial release.
