module wifiLogo() {
  union() {
    difference() {
      difference() {
        import(file = "outline.svg", center=true, dpi=96);
        translate([136, -4, 0])
          import(file = "cut.svg", center=true, dpi=96);
      };
      translate([-190, -4, 0])
        import(file = "w.svg", center=true, dpi=96);
      translate([-72, -.05, 0])
        import(file = "i.svg", center=true, dpi=96);
    };

    translate([130, -4, 0])
      import(file = "f.svg", center=true, dpi=96);

    translate([235, -.05,0])
      import(file = "i_2.svg", center=true, dpi=96);
  };
};