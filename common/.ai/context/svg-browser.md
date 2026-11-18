# SVG and browser verification

Read when generating or inspecting SVG, CSS, browser measurements, or raster overlays. These checks also apply when another language generates the rendered files.

- Use Chromium headless-shell for CLI rendering when regular Chromium hangs.
- Allow CSSOM rounding when verifying fractional percentage positions.
- Verify SVG text bounds in the browser; successful raster rendering can hide clipping.
- Check serialized SVG transforms separately from float32 browser matrix values.
- Compare SVG bounds and viewports in the same coordinate system.
- Check SVG clipping inherited from ancestor groups.
- Validate visibility, placement and every reference to SVG geometry used as evidence.
- Reject non-finite browser measurements before JSON serialization.
- Verify raster coverage at every viewport corner after rotation.
- Poll asynchronous browser state instead of assuming fixed delays complete work.
- Clarify whether visual feedback targets the base image or a toggled overlay.
- Treat CSS function names case-insensitively while preserving identifier case.
- Tokenize SVG path data before checking numeric finiteness.
- Verify browser availability before promising control or recommending Chrome installation.
