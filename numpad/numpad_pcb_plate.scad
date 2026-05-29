// ============================================================
//  Caldera Numpad — PCB Plate
//  Mimics a PCB: 5 holes per switch for mechanical retention.
//  No actual PCB — switches are hand-wired directly.
//
//  Kailh Choc v1 (PG1350) hole layout (relative to switch center):
//
//  (-5.5, 0)          (0, 0)          (+5.5, 0)
//    leg L    O---------O---------O    leg R     <- same horizontal axis
//                    centre post
//
//                       O  (0,    -5.9)  pin 1
//                 O  (-5.0, -3.8)  pin 2
//
//  Support legs:  Y = 0,     X = ±5.5mm
//  Centre post:   (0, 0)
//  Pin 1:         (0,    -5.9mm)
//  Pin 2:         (+5.0, -3.8mm)
//
//  Hole diameters:
//    Support legs   2.0mm  (body ~1.9mm + 0.1mm clearance)
//    Centre post    3.4mm  (body ~3.2mm + 0.2mm clearance)
//    Signal pins    1.4mm  (body ~1.2mm + 0.2mm clearance)
//
//  Top-right position (encoder) gets a single 7.5mm shaft hole.
// ============================================================

// ---- Shared dimensions (must match numpad_case.scad) -------
key_pitch       = 18.75;
cols            = 4;
rows            = 4;
pad_x           = 6;
pad_y           = 6;
switch_cutout   = 13.8;
fillet_r        = 2.0;
plate_thickness = 1.5;

board_w = (cols - 1) * key_pitch + switch_cutout + pad_x * 2;
board_h = (rows - 1) * key_pitch + switch_cutout + pad_y * 2;

// ---- Choc v1 (PG1350) hole dimensions ----------------------

// Support legs — same Y axis as centre post
leg_x           =  5.5;   // ±5.5mm from centre post
leg_y           =  0.0;
leg_d           =  2.3;   // body ~1.9mm + 0.4mm clearance

// Centre locating post
post_d          =  3.7;   // body ~3.2mm + 0.5mm clearance

// Signal pins — staggered, not on the same row
pin1_x          =  0.0;
pin1_y          = -5.9;   // directly below centre post

pin2_x          = -5.0;   // 5.0mm to the left of pin 1
pin2_y          = -3.8;   // 3.8mm below centre post

pin_d           =  1.7;   // body ~1.2mm + 0.5mm clearance

// ---- Encoder shaft hole ------------------------------------
encoder_shaft_d = 7.5;

// ============================================================
//  Helpers
// ============================================================

module rounded_rect(w, h, r) {
    offset(r=r) offset(r=-r) square([w, h], center=true);
}

module hole(x, y, d) {
    translate([x, y, -0.1])
        cylinder(h = plate_thickness + 0.2, d = d, $fn = 32);
}

// ============================================================
//  Five-hole footprint for a single Choc v1 switch.
//  Call already translated to the switch centre.
// ============================================================
module choc_switch_holes() {
    // Support legs (left and right, same Y as centre post)
    hole(-leg_x, leg_y, leg_d);
    hole( leg_x, leg_y, leg_d);
    // Centre locating post
    hole(0, 0, post_d);
    // Signal pins (staggered below centre)
    hole(pin1_x, pin1_y, pin_d);
    hole(pin2_x, pin2_y, pin_d);
}

// ============================================================
//  Full PCB plate
// ============================================================
module pcb_plate() {
    difference() {
        linear_extrude(plate_thickness)
            rounded_rect(board_w, board_h, fillet_r);

        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                x = (c - (cols - 1) / 2) * key_pitch;
                y = (r - (rows - 1) / 2) * key_pitch;

                translate([x, y, 0]) {
                    if (c == cols - 1 && r == rows - 1) {
                        hole(0, 0, encoder_shaft_d);
                    } else {
                        choc_switch_holes();
                    }
                }
            }
        }
    }
}

// ============================================================
//  Render
// ============================================================
color("DarkSlateGray") pcb_plate();
