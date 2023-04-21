include <qrcode-matrix.scad>
include <wifi-logo/logo.scad>

// -- Parameters --
/* [Settings] */
// If checked, only the model of the QR-code and the logo are rendered. Otherwise, a card with indented QR-code and logo is shown.
qrCodeOnly=false;
// If checked, a void for an NFC tag will be added in the center of the card. The dimensions and depth can be edited in the NFC tag section.
nfcTag=false;
// Print layer height. This defines how deep QR-code and logo indents are. It should be set to the height of a single print layer. You can set it to multiple layer heights, but the nozzle will likely interfere with the already printed QR-code during card printing.
layerHeight=0.2;
/* [Model] */ 
// Width, Length, Height
cardSize=[70, 100, 4];
// Distance from the edge of the card to the QR-code.
margin=6;
// Chamfer size on the edges of the card.
chamfer=1;
// Clearance between the top of the QR-code and the QR-code indent.
qrOffsetVertical=0.1;
// Clearance between the sides of the QR-code and the walls of the QR-code indent.
qrOffsetHorizontal=0.0;
// Fillet radius on the corners of the card.
cornerRadius = 5;
/* [NFC tag] */
// Height, Radius
nfcTagSize=[ 0.4, 13 ];
// Depth of the NFC tag from the face of the card.
nfcTagDepth=1.5;
// ----------------

/* [Hidden] */
eps=0.001;
$fn=100;

module qrCode(of, h, cl, data) {
  // Experimental gap between each QR code cell. It is better to leave it at 0.
  gap=0;
  _gap=(gap >0 ? gap + 2 * of : 0);
  _cl=cl - _gap;
  linear_extrude(height = h) {
    offset(delta = of) {
      union() {
        x = 0;
        y = 0;
        for (rowIndex = [ 0 : len(data) - 1 ] ) {
          row = data[rowIndex];
          union() {
            for (columnIndex = [ 0 : len(row) - 1 ] ) {
              value = row[columnIndex];
              if (value == 1) {
                  translate([x, - y - _cl, 0])
                    square([_cl, _cl]);
              }
              y = y + (_cl + _gap - eps) * columnIndex - of ;
            }
          };
          x = x + (_cl + _gap - eps) * rowIndex - of;
        }
      }
    }
  }
};

module card(size, m, ch, r, layer, qrOffsetH, qrOffsetV, data) {
  qrSideLength=size.x - 2 * m;
  qrVerticalCount=len(data);
  qrHorizontalCount=len(data[0]);
  cellSide=qrSideLength / qrHorizontalCount;
  qrHeight=qrVerticalCount * (cellSide - eps);
  qrWidth=qrHorizontalCount * (cellSide - eps);
  logoYPos=(size.y - (qrHeight + m))/2;
  
  if (!qrCodeOnly) { // Card body
    difference() { // NFC tag void
      difference() { // Deboss Wifi logo
        difference() { // Deboss QR-code
          translate([ r + ch, r + ch, 0 ])
            // Chamfering the top edges.
            minkowski() {
              // Rounding corners.
              minkowski() {
                translate([ 0, 0, - 2 * eps ])
                  cube([ size.x - 2 * (r + ch), size.y - 2 * (r + ch), size.z - ch + eps ]); 
                cylinder(h=eps, r = r);
              };
              cylinder(h=ch, r1=ch, r2=0);
            }
          // QR Code
          translate([ m, size.y - m, size.z - (layer + qrOffsetV) ])
            qrCode(qrOffsetH, layer +  qrOffsetV, cellSide, data);
        };
        // Wifi logo
        translate([ size.x / 2, logoYPos, size.z - (layer + qrOffsetV)  ])
          linear_extrude(layer + qrOffsetV)
            scale(0.05)
              wifiLogo();
      };
      if (nfcTag) {
        translate([ size.x / 2, size.y / 2, size.z - (nfcTagSize.x + nfcTagDepth) ])
          cylinder(nfcTagSize.x, r=nfcTagSize.y);
      }
    };
  } else { // Deboss QR-code and wifi logo
    // Dummy frame to fit the same bounding box of the card. Used for slicers' auto-arrange functionality.
    translate([ 0, 0, size.z  ])
      difference() {
        cube([ size.x, size.y, eps ]);
        translate([ eps, eps, 0  ])
          cube([ size.x - 2 * eps, size.y - 2 * eps, eps ]);
      };
    // QR-code
    translate([ m, size.y - m, size.z - layer  ])
      qrCode(0, layer, cellSide, data);
    // Wifi logo
    translate([ qrWidth / 2 + m, logoYPos, size.z - layer ])
      linear_extrude(layer)
        scale(0.05)
          wifiLogo();
  }
};

// -- Orienting for printing --
rotate([180, 0, 180])
  translate([ - cardSize.x / 2, - cardSize.y / 2, -cardSize.z ])
// ----------------------------
    card(cardSize, margin, chamfer, cornerRadius, layerHeight, qrOffsetHorizontal, qrOffsetVertical, qrData);
