# Volca Case
Transport case and dust protector for all Korg Volca synthesizers, made with OpenSCAD.

\<TODO images\>

## How to build one
Download pre-made 2D templates from the releases page or customize and create your own template (see below). Then laser the parts and assemble the case (glue recommended).

## How to customize
Multiple things about the case can be customized, such as:
* case thickness
* laser kerf compensation
* larger cutouts to accomodate space for bulky cables
* disabling cutouts in the lid altogether

The case is made with OpenSCAD. You will need to install:
* [OpenSCAD](http://www.openscad.org/)
* the [lasercut](https://github.com/bmsleight/lasercut) library
* the (**linux only!**) [laserscad](https://github.com/mbugert/laserscad/) library

Once these are set up, you can customize the case by changing stuff in ``modules/case_settings.scad``. Then, follow the instructions at "Exporting to 2D" in the [laserscad readme](https://github.com/mbugert/laserscad/blob/master/README.md) to create your 2D template.