// ============================================================
//  Caldera Numpad — Bottom Plate
//  Flat plate + EC11 encoder housing + snap clips (inward)
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

// EC11 Rotary Encoder Housing — corner post design
// Four L-shaped posts grip the encoder at its corners.
// All four sides are fully open: pins and legs are accessible for hand-wiring.
enc_body_w       = 11.7;   // encoder body width  (X), from datasheet
enc_body_d       = 12.0;   // encoder body depth  (Y), from datasheet
enc_tolerance    = 0.1;    // clearance per side
enc_corner       = 3.0;    // ADJUST: how far each L-post wraps along each edge
enc_wall         = 1.5;    // L-post wall thickness (outward from body face)
enc_height       = 5.0;    // post height above plate surface

// Derived — inner slot dimensions (body + tolerance)
enc_slot_w       = enc_body_w + enc_tolerance * 2;
enc_slot_d       = enc_body_d + enc_tolerance * 2;

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

// EC11 encoder housing — four L-shaped corner posts.
//
// Top view of one corner (bottom-left shown, others are mirrors):
//
//   +--+
//   |  |  <- enc_wall (outward thickness)
//   +--+--...open...
//      |  <- enc_wall
//      +
//
// The encoder body drops in from above; the four corners locate it in X and Y.
// All four sides between the posts are fully open for pin/leg access.
// No bottom floor — encoder rests directly on the plate surface.
// No shaft hole needed (shaft points up through the open top).
//
// enc_corner controls how far each leg of the L extends along the encoder edge.
// Increase it for a tighter grip; decrease it to open up more side access.

module enc_corner_post(sx, sy) {
    // sx, sy: +1 or -1 — selects which corner
    // Post origin is at the outer corner; L-arms extend inward along each axis.
    translate([pot_x + sx * (enc_slot_w/2 + enc_wall),
               pot_y + sy * (enc_slot_d/2 + enc_wall),
               plate_thickness]) {
        // Arm along X direction (runs parallel to X axis)
        translate([sx < 0 ? 0 : -(enc_corner + enc_wall),
                   sy < 0 ? 0 : -enc_wall,
                   0])
            cube([enc_corner + enc_wall,
                  enc_wall,
                  enc_height]);

        // Arm along Y direction (runs parallel to Y axis)
        translate([sx < 0 ? 0 : -enc_wall,
                   sy < 0 ? 0 : -(enc_corner + enc_wall),
                   0])
            cube([enc_wall,
                  enc_corner + enc_wall,
                  enc_height]);
    }
}

module encoder_housing() {
    enc_corner_post(-1, -1);  // front-left
    enc_corner_post( 1, -1);  // front-right
    enc_corner_post(-1,  1);  // back-left
    enc_corner_post( 1,  1);  // back-right
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
    color("DimGray")        encoder_housing();
    color("CornflowerBlue") snap_clips();
}

numpad_bottom();
