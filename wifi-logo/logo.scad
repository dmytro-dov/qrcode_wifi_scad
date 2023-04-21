module wifiLogo() {
  union() {
    difference() {
      difference() {
        import(file = "wifi-logo/outline.svg", center=true, dpi=96);
        translate([136, -4, 0])
          import(file = "wifi-logo/cut.svg", center=true, dpi=96);
      };
      translate([-190, -4, 0])
        import(file = "wifi-logo/w.svg", center=true, dpi=96);
      translate([-72, -.05, 0])
        import(file = "wifi-logo/i.svg", center=true, dpi=96);
    };

    translate([130, -4, 0])
      import(file = "wifi-logo/f.svg", center=true, dpi=96);

    translate([235, -.05,0])
      import(file = "wifi-logo/i_2.svg", center=true, dpi=96);
  };
};