# Bitmap editor

The editor will read a text file and output the result of the instructions provided to STDOUT.

## Basic commands

* I - Initialize bitmap. Should be followed by the `width` and `height`.
* C - Clears the bitmap, restoring to original state.
* L - Prints a point. Should be followed by the `x`, `y` and `color` to be printed.
* V - Prints a vertical line. Should be followed by `x`, initial `y`, final `y` and `color` to be printed.
* H - Prints a horizontal line. Should be followed by initial `x`, final `x`, `y` and `color` to be printed.
* S - Prints the image.

## Example

```
I 5 6
C
L 1 3 A
V 2 3 6 W
H 3 5 2 Z
S
```
