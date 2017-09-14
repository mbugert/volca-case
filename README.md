# Laser-cut Korg Volca Case
Transport case and dust protector for Korg Volca synthesizers.

\<img\>

Currently compatible with **Beats** and **Sample**. Support for the rest of the family is planned.

## How to build one
Download pre-made 2D templates from the releases page or customize and create your own template (see below). Then laser the parts and assemble the case (glue recommended).

## How to customize
Multiple things about the case can be customized, such as:
* case thickness
* laser kerf compensation
* larger cutouts to accomodate space for bulky cables
* disabling cutouts in the lid altogether

The case is made with OpenSCAD. You will need to install:
* OpenSCAD
* the lasercut library
* the (**linux-only!**) laserscad library

Once these are set up, open ``korg_volca_case.scad`` with OpenSCAD and modify the customization variables at the top of the file. Then, follow the instructions at "Exporting to 2D" in the laserscad readme to create a 2D template.