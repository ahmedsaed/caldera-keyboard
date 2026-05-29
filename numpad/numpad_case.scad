// ============================================================
//  Caldera Numpad Case
//  4x4 Choc switch plate + side walls + snap ridges (inward)
// ============================================================

switch_cutout    = 13.8;
cols             = 4;
rows             = 4;
key_pitch        = 18.75;
plate_thickness  = 1.2;
wall_thickness   = 2.5;
wall_height      = 16.0;
fillet_r         = 2.0;
pad_x            = 6;
pad_y            = 6;

// Snap ridge
ridge_height     = 1.2;   // vertical thickness of the shelf
ridge_depth      = 1.0;   // how far it sticks inward from the wall
ridge_width      = 8.0;   // length along the wall
ridge_z          = 3.0;   // Z of the TOP of the ridge from case bottom

board_w = (cols - 1) * key_pitch + switch_cutout + pad_x * 2;
board_h = (rows - 1) * key_pitch + switch_cutout + pad_y * 2;

module rounded_rect(w, h, r) {
    offset(r=r) offset(r=-r) square([w, h], center=true);
}

// --- Single ridge -------------------------------------------
//  A horizontal wedge: flat on top (hook locks here),
//  angled on the bottom (hook cams up over it on insertion).
//  Profile is in the XZ plane, extruded along Y for ridge_width.
//  Protrudes in +X direction (caller mirrors/rotates for each wall).
//
//        wall
//         |\_____  <- flat top face (hook locks here)
//         |      \
//         |       \ <- angled bottom face (hook slides up this)
//         |________\
//
module ridge() {
    translate([0, ridge_width/2, 0])
        rotate([90, 0, 0])
            linear_extrude(ridge_width)
                polygon([
                    [0,           0          ],  // wall base
                    [ridge_depth, ridge_height/2],  // outer tip bottom (angled)
                    [0,           ridge_height]  // wall top (flat top face)
                ]);
}

// --- Four ridges, one per wall, all protruding inward -------
module snap_ridges() {
    z = ridge_z - ridge_height;

    // Front wall (inner face at Y = -board_h/2 + wall_thickness)
    // protrudes inward = +Y direction → rotate ridge to point +Y
    translate([0, -board_h/2 + wall_thickness, z])
        rotate([0, 0, 90])
            ridge();

    // Back wall (inner face at Y = +board_h/2 - wall_thickness)
    // protrudes inward = -Y direction
    translate([0, board_h/2 - wall_thickness, z])
        rotate([0, 0, -90])
            ridge();

    // Left wall (inner face at X = -board_w/2 + wall_thickness)
    // protrudes inward = +X direction
    translate([-board_w/2 + wall_thickness, 0, z])
        ridge();

    // Right wall (inner face at X = +board_w/2 - wall_thickness)
    // protrudes inward = -X direction
    translate([board_w/2 - wall_thickness, 0, z])
        mirror([1, 0, 0])
            ridge();
}

module plate() {
    difference() {
        linear_extrude(plate_thickness)
            rounded_rect(board_w, board_h, fillet_r);
for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                x = (c - (cols - 1) / 2) * key_pitch;
                y = (r - (rows - 1) / 2) * key_pitch;
                translate([x, y, -0.1])
                    linear_extrude(plate_thickness + 0.2)
                        if (c == cols - 1 && r == rows - 1)
                            circle(r = 3.75, $fn = 64);  // encoder shaft hole (7.5mm diameter)
                        else
                            square([switch_cutout, switch_cutout], center=true);
            }
        }
    }
}

module walls() {
    linear_extrude(wall_height)
        difference() {
            rounded_rect(board_w, board_h, fillet_r);
            rounded_rect(board_w - wall_thickness * 2,
                         board_h - wall_thickness * 2,
                         max(fillet_r - wall_thickness, 0.5));
        }
}

module numpad_case() {
    color("SlateGray") walls();
    color("SlateGray") snap_ridges();
    color("DimGray")   translate([0, 0, wall_height]) plate();
}

numpad_case();
