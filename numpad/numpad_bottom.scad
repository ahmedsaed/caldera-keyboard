// ============================================================
//  Caldera Numpad — Bottom Plate
//  Flat plate + potentiometer housing + snap clips (inward)
// ============================================================

key_pitch        = 18.75;
cols             = 4;
rows             = 4;
pad_x            = 6;
pad_y            = 6;
switch_cutout    = 13.8;
fillet_r         = 2.0;
wall_thickness   = 2.5;
plate_thickness  = 1.2;

pot_inner_r      = 16.5 / 2;
pot_wall         = 2.0;
pot_outer_r      = pot_inner_r + pot_wall;
pot_height       = 3.5;

// Snap clip (must match numpad_case.scad)
ridge_height     = 1.2;
ridge_depth      = 1.0;
ridge_width      = 8.0;
ridge_z          = 3.0;
clip_thickness   = 1.2;
clip_gap         = 0.3;
clip_height      = ridge_z + ridge_height + 1.0;

board_w = (cols - 1) * key_pitch + switch_cutout + pad_x * 2;
board_h = (rows - 1) * key_pitch + switch_cutout + pad_y * 2;

pot_x = ((cols - 1) / 2) * key_pitch;
pot_y = ((rows - 1) / 2) * key_pitch;

module rounded_rect(w, h, r) {
    offset(r=r) offset(r=-r) square([w, h], center=true);
}

module bottom_plate() {
    linear_extrude(plate_thickness)
        rounded_rect(board_w, board_h, fillet_r);
}

// Pot housing goes UPWARD (into the case), closed bottom = plate itself
module pot_housing() {
    translate([pot_x, pot_y, plate_thickness])
        difference() {
            cylinder(h = pot_height, r = pot_outer_r, $fn = 64);
            translate([0, 0, -0.1])
                cylinder(h = pot_height + 0.2, r = pot_inner_r, $fn = 64);
        }
}

// --- Single clip arm + hook ---------------------------------
//  Arm: vertical wall standing up from the plate (+Z).
//  Hook: horizontal wedge at the top of the arm.
//    - Flat bottom face: locks UNDER the ridge flat top face.
//    - Angled top face: cams OVER the ridge when pressing plate up.
//  The tip of the triangle points AWAY from the arm (outward toward wall),
//  so the ramp faces upward/outward — correct for sliding past the ridge.
//
//    wall side
//       |
//       |    /|  <- angled top (cams over ridge going up)
//       |   / |
//       |  /  |  <- flat bottom (locks under ridge)
//       | /   |
//       |/arm |
//  plate+-----+
//
module snap_clip() {
    // Vertical arm
    cube([clip_thickness, ridge_width, clip_height], center=false);

    // Hook: tip points in +X (away from arm base, toward wall)
    // Flat face at bottom of hook, angled face at top
    translate([clip_thickness, ridge_width, clip_height - ridge_height])
        rotate([90, 0, 0])
            linear_extrude(ridge_width)
                polygon([
                    [0,                      ridge_height],  // arm top, inner — angled face starts here
                    [ridge_depth + clip_gap,  ridge_height/2],  // tip — angled ramp points up+out
                    [0,                      0            ]   // arm base, inner — flat bottom face
                ]);
}

// --- Four clips, one per side, inside the case walls --------
module snap_clips() {
    inner_w = board_w - wall_thickness * 2;
    inner_h = board_h - wall_thickness * 2;

    // Front — hook points toward front wall (-Y)
    translate([-ridge_width/2, -inner_h/2, plate_thickness])
        rotate([0, 0, -90])
            snap_clip();

    // Back — hook points toward back wall (+Y)
    translate([ridge_width/2, inner_h/2, plate_thickness])
        rotate([0, 0, 90])
            snap_clip();

    // Left — hook points toward left wall (-X)
    translate([-inner_w/2, ridge_width/2, plate_thickness])
        rotate([0, 0, 180])
            snap_clip();

    // Right — hook points toward right wall (+X)
    translate([inner_w/2, -ridge_width/2, plate_thickness])
        rotate([0, 0, 0])
            snap_clip();
}

module numpad_bottom() {
    color("SlateGray")      bottom_plate();
    color("DimGray")        pot_housing();
    color("CornflowerBlue") snap_clips();
}

numpad_bottom();
