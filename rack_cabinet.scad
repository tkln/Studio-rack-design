/* The base unit is mm unless ontherwise implied. All other units are derived 
 * from that
 */
// Conversion ratios
in = 25.4;
u = 1.75 * in;


rack(10, 16, 25, 50, 50, 11);

module rack (top_rack_units, front_rack_units, material_thickness,
        bottom_blank_height, top_blank_height, front_rack_angle)
{
    // These values have material thickness and other things taken into account
    front_side_lenght = (front_rack_units * u) + top_blank_height +
                        bottom_blank_height; 
    top_side_lenght = sqrt(pow(tan(front_rack_angle) * material_thickness, 2) +
            pow(material_thickness, 2)) + u * top_rack_units;
    bottom_lenght = top_side_lenght + front_side_lenght * sin(front_rack_angle);

    top_rack_start = front_side_lenght * sin(front_rack_angle) +
        cos(front_rack_angle) * material_thickness;

    rail_thickness = 4;
    rail_width = 0.625 * in;

    module side_panel(x, y, z)
    {
        translate(v = [x, y, z])
        { 
            linear_extrude(height = material_thickness, center = false,
                           convexity = 0, twist = 0)
            {
                polygon(points = [
                        [0, 0],
                        [front_side_lenght * sin(front_rack_angle), 
                        front_side_lenght * cos(front_rack_angle)],
                        [bottom_lenght, front_side_lenght *
                        cos(front_rack_angle)],
                        [bottom_lenght, 0]],
                        paths = [[0, 1, 2, 3]]);
            }
        }
    }

    module blank (blank_height)
    {
        linear_extrude(height =  19 * in, center = false, convexity = 0, 
                       twist = 0)
        {
            polygon(points = [
                    [0, 0],
                    [material_thickness, 0],
                    [material_thickness, blank_height],
                    [0, blank_height - tan(front_rack_angle) * 
                    material_thickness]
                    ],
                    paths = [[0, 1, 2, 3]]);
        }
    }

    module top_blank()
    {
        rotate(a = [90, front_rack_angle, 90])
        {
            translate(v = [0, bottom_blank_height + front_rack_units * u +
                      tan(front_rack_angle) *
                      material_thickness, material_thickness])
            {
                blank(top_blank_height);
            }
        }
    }

    module bottom_blank()
    {
        rotate(a = [90, front_rack_angle + 180, 90])
        {
            translate(v = [-material_thickness, -bottom_blank_height, 
                      material_thickness]){
                blank(bottom_blank_height);
            }
        }
    }
    
    module rails()
    {
        // Left top rail
        translate(v = [material_thickness, top_rack_start, front_side_lenght -
                  material_thickness]){
            rack_rail(u * top_rack_units, rail_thickness);
        }

        // Right top rail
        translate(v = [19 * in + rail_width / 2, top_rack_start, 
                  front_side_lenght - material_thickness]){
            rack_rail(u * top_rack_units, rail_thickness);
        }

        // Left front rail
        rotate(a = [90 - front_rack_angle, 0, 0])
        {
            translate(v = [material_thickness, bottom_blank_height, 
                      -2 * rail_thickness]){
                rack_rail(u * front_rack_units, rail_thickness);
            }
        }
       
        // Right front rail 
        rotate(a = [90 - front_rack_angle, 0, 0])
        {
            translate(v = [19 * in + rail_width/2, bottom_blank_height, 
                      -2 * rail_thickness]){
                rack_rail(u * front_rack_units, rail_thickness);
            }
        }
    }
   
    module bottom()
    {
        translate(v = [0, 0, -material_thickness])rotate(a = [0, 0, 0])
        {
            linear_extrude(height = material_thickness, center = false,
                           convexity = 0, twist = 0)
            {
                polygon(points = [
                        [0, 0], 
                        [0, bottom_lenght], 
                        [19 * in + 2 *material_thickness, bottom_lenght], 
                        [19 * in + 2 * material_thickness, 0]],
                        paths = [[0, 1, 2, 3]]);
            }
        }
    }

    top_blank();
    bottom_blank();
    rails();
    bottom();

    rotate(a = [90, 0, 90])
    {
        side_panel(0,0,0);
        side_panel(0,0, 19 * in + material_thickness);

    }
}

module rack_rail(len, thickness)
{
    rail_width = 0.625 * in;
    hole_spacing = 0.625 * in;
    color([0.2, 0.2, 0.2])
    {
        linear_extrude(height = thickness, center = false, convexity = 0, 
                       twist = 0)
        {
            difference()
            { 
                polygon(points = [
                        [0,0],
                        [rail_width, 0],
                        [rail_width, len],
                        [0, len]],
                        paths = [[0, 1, 2, 3]]);

                for(i = [0 : (len / hole_spacing)]){
                    translate(v = [rail_width / 2, hole_spacing * (0.5 + i), 0])
                    {
                        circle(r = 3);
                    }
                }
            }
        }
    }

}


