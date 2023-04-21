# WiFi QR-code Card

A script to generate a simple WiFi QR-code card for 3D printing using Python and OpenSCAD.

## Requirements

- [Python 3](https://www.python.org/downloads/):
  - [qrcode](https://pypi.org/project/qrcode/) package.
- [OpenSCAD 2021.01](https://openscad.org/downloads.html).

## Usage

Run the following command in your favorite shell:

```bash
python ./generate.py "string-to-encode"
```

Replace `string-to-encode` with any information you want QR-code to encode.

Generated STL files will be saved in the `output` directory.

### Changing model parameters

Various card model parameters can be modified in the 'wifi-card.scad' file.

This can be done either in code or using OpenSCAD's "Customizer", which can be accessed via the `Window -> Customizer` menu in OpenSCAD.

### Encoding Wifi data

WiFi network information can be encoded using [ZXign's format](https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11). 

 ```bash
 python ./generate.py "WIFI:S:My guest network;T:WPA;P:AVerySecurePassword123;;"
 ```

### 3D Printing

This model was designed to be printed using the Z-hop method. However, there is no reason for multi-material systems not to work. I don't have any on hand, hence this model was not tested with them.

For this to work, generated STLs need to be sliced and printed separately. When the second model is printing, a Z-hop value higher than the print layer height should make the nozzle clear the first model.

Make sure the printer's homing is repeatable; otherwise, it may result in model misalignment.

For the best result, the first layer should be well calibrated.

  1. Before generating STLs, make sure to set the `layerHeight` parameter in `wifi-card.scad` to the desired value (0.2mm by default).
  2. Generate STLs and import both models into a slicer of your choice.
  3. Ensure that both models are centered in the middle of the bed and aligned.
    - In Cura, XYZ coordinates can be set to [0, 0, 0] for each model.
    - In PrusaSlicer, when both STLs are imported simultaneously, they should already be aligned. X/Y coordinates can also be manually set to half the width/length of the print bed.
  4. Slice the `qrcode.stl` model normally and print it with a color of your choosing. **Do not remove the print from the print bed!**
  5. Change the filament to a different color. Remove Brim if present.
  6. In the slicer, set the Z-hop value to be slightly higher than the layer height (to about 0.4 for a 0.2 layer height) of the `qrcode.stl` model.
    - In Cura, change `Z Hop Height`.
    - In PrusaSlicer, change `Printer Settings -> Lift Z`.
  7. Slice and print the `main_body.stl`.

By following these steps, `main_body.stl` should be printed over `qrcode.stl`, resulting in a two-color pattern on the first layer.

