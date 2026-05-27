function xl_board_numpad_key_cutouts_extrude_1_2_outline_fn(){
    return new CSG.Path2D([[187.5,-162],[187.5,-157]]).appendPoint([263.25,-157]).appendPoint([263.25,-143]).appendPoint([260.75,-143]).appendPoint([260.75,-140]).appendPoint([246.75,-140]).appendPoint([246.75,-143]).appendPoint([200.75,-143]).appendPoint([200.75,-140]).appendPoint([187.5,-140]).appendPoint([187.5,-139.25]).appendPoint([263.25,-139.25]).appendPoint([263.25,-125.25]).appendPoint([260.75,-125.25]).appendPoint([260.75,-122.25]).appendPoint([246.75,-122.25]).appendPoint([246.75,-125.25]).appendPoint([200.75,-125.25]).appendPoint([200.75,-122.25]).appendPoint([187.5,-122.25]).appendPoint([187.5,-121.5]).appendPoint([263.25,-121.5]).appendPoint([263.25,-107.5]).appendPoint([260.75,-107.5]).appendPoint([260.75,-104.5]).appendPoint([246.75,-104.5]).appendPoint([246.75,-107.5]).appendPoint([200.75,-107.5]).appendPoint([200.75,-104.5]).appendPoint([187.5,-104.5]).appendPoint([187.5,-103.75]).appendPoint([263.25,-103.75]).appendPoint([263.25,-89.75]).appendPoint([260.75,-89.75]).appendPoint([260.75,-86.75]).appendPoint([246.75,-86.75]).appendPoint([246.75,-89.75]).appendPoint([200.75,-89.75]).appendPoint([200.75,-86.75]).appendPoint([187.5,-86.75]).appendPoint([187.5,-84.75]).appendPoint([265.5,-84.75]).appendPoint([265.5,-97.75]).appendPoint([268.75,-97.75]).appendPoint([268.75,-101.5]).appendPoint([265.5,-101.5]).appendPoint([265.5,-115.5]).appendPoint([268.75,-115.5]).appendPoint([268.75,-119.25]).appendPoint([265.5,-119.25]).appendPoint([265.5,-133.25]).appendPoint([268.75,-133.25]).appendPoint([268.75,-137]).appendPoint([265.5,-137]).appendPoint([265.5,-151]).appendPoint([268.75,-151]).appendPoint([268.75,-162]).appendPoint([187.5,-162]).close().innerToCAG()
.extrude({ offset: [0, 0, 1.2] });
}




                function numpad_plate_case_fn() {
                    

                // creating part 0 of case numpad_plate
                let numpad_plate__part_0 = xl_board_numpad_key_cutouts_extrude_1_2_outline_fn();

                // make sure that rotations are relative
                let numpad_plate__part_0_bounds = numpad_plate__part_0.getBounds();
                let numpad_plate__part_0_x = numpad_plate__part_0_bounds[0].x + (numpad_plate__part_0_bounds[1].x - numpad_plate__part_0_bounds[0].x) / 2
                let numpad_plate__part_0_y = numpad_plate__part_0_bounds[0].y + (numpad_plate__part_0_bounds[1].y - numpad_plate__part_0_bounds[0].y) / 2
                numpad_plate__part_0 = translate([-numpad_plate__part_0_x, -numpad_plate__part_0_y, 0], numpad_plate__part_0);
                numpad_plate__part_0 = rotate([0,0,0], numpad_plate__part_0);
                numpad_plate__part_0 = translate([numpad_plate__part_0_x, numpad_plate__part_0_y, 0], numpad_plate__part_0);

                numpad_plate__part_0 = translate([0,0,0], numpad_plate__part_0);
                let result = numpad_plate__part_0;
                
            
                    return result;
                }
            
            
        
            function main() {
                return numpad_plate_case_fn();
            }

        