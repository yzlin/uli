# uli

`uli` is a ***rewritten version*** of [drawrect](https://github.com/chendo/drawrect) using native language instead of RubyMotion.

## Screenshot

![Screenshot](https://github.com/chendo/drawrect/raw/master/screenshot.png)

## Usage

`uli` was designed to be used from within `lldb`

* `dr object.bounds`  - draws a rect at object.bounds using bottom-left origin
* `drf object.bounds` - draws a rect at object.bounds using top-left origin
* `drc`               - clears all rects

You can use it from the command line as well.

```sh
Usage:
uli rect <rect> [label] [colour] [opacity] - draws a rect with bottom left origin
uli flipped_rect <rect> [label] [colour] [opacity] - draws a rect with top left origin
uli clear - clears all rects
uli quit - quits server
```

## License

See [LICENSE](license) for details.

[license]: uli/blob/master/LICENSE