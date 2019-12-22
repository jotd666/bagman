#ifndef GUARDTABLES_H_INCLUDED
#define GUARDTABLES_H_INCLUDED

/*
    Copyright (C) 2010 JOTD

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

    // the tables have been ripped from the original arcade game
    // the format is either
    // little endian LSB+MSB of the logical rounded address (2 bytes) + direction 0x40 or 0x80 (right) (1 byte)
    // or little endian LSB+MSB of the logical rounded address (2 bytes)
    // terminated by 0xFF

    // direction branch table: 3 bytes (address then direction mask)
    static const unsigned char direction_branch_table[] = { 0x40,0xC4,0xE0,0x40,
            0xCA,0xD0,0x42,0xE4,0xA0,0x42,0xEA,0xB0,0x42,0xEE,0xB0,0x42,
            0xF0,0x70,0x42,0xF5,0xB0,0x43,0x70,0xB0,0x43,0x78,0x90,
            0x41,0x6F,0x60,  // this one looks useless and buggy: in the original game it does not seem to work either
            0x41,0x74,0xD0,0x42,0xF8,0x70,0x42,0xFA,0xB0,0x42,0xFE,0xD0,0x44,0x87,0xE0,0x44,0x8F,0xD0,
            0x45,0x27,0xA0,0x45,0x2C,0x90,0x45,0x4F,0x80,0x44,0xB3,0x80,0x45,0x13,0x40,0x45,
            0x19,0x60,0x45,0x1B,0xB0,0x45,0x1E,0xD0,0x45,0xAA,0x40,0x46,0xCA,0xD0,0x47,0x6A,
            0xE0,0x47,0x6E,0x90,0x46,0x73,0xE0,0x46,0x78,0xB0,0x46,0x7E,0xD0,0x46,0xC4,0xE0,
            0x48,0xE4,0xE0,0x48,0x87,0x60,0x48,0x8B,0x50,0x48,0xEB,0xE0,0x4A,0x27,0xE0,0x4A,
            0x2B,0x90,0x48,0xF4,0xD0,0x48,0x94,0x60,0x48,0x9B,0x50,0x49,0xD1,0x60,0x49,0xD4,
            0x90,0x49,0xD7,0xE0,0x49,0xDB,0xD0,0x4A,0xE7,0x80,0x4A,0xF0,0x80,0x4A,0xF7,0x80,
            0x4B,0x47,0x40,0x4B,0x53,0x40,0x48,0xE7,0xD0,
            0xFF
                                                          };


    // waiting point table and guide tables: 2+1 bytes
    static const unsigned char waiting_point_table[] = {0x45,0x44,0x40,
            0x45,0x4F,0x40,
            0x45,0x53,0x40,
            0x45,0xA4,0x80,
            0x45,0xAA,0x80,
            0x45,0xB3,0x80,
            0x4A,0xE4,0x40,
            0x4A,0xE7,0x40,
            0x4A,0xF0,0x40,
            0x4A,0xF7,0x40,
            0x4A,0xFB,0x40,
            0x4B,0x44,0x80,
            0x4B,0x47,0x80,
            0x4B,0x53,0x80,
            0x4B,0x5B,0x80,0xFF
                                                       };



    static const unsigned char guide_from_1_to_2[] = {0x40,0xC4,0x80,0x40,0xCA,0x80,
            0x42,0xE4,0x80,0x42,0xEA,0x80,0x42,0xEE,0x10,0x42,
            0xF0,0x10,0x42,0xF5,0x10,0x43,0x70,0x80,0x43,0x78,0x80,0x41,0x6F,0x40,0x41,0x74,
            0x40,0x42,0xF8,0x20,0x42,0xFA,0x20,0x42,0xFE,0x80,0xFF
                                                     };

    static const unsigned char guide_from_2_to_1[] = {0x44,0x87,0x20,
            0x44,0x8F,0x40,0x45,0x27,0x80,0x45,0x2C,0x10,0x45,0x4F,0x40,0x44,0xB3,0x40,0x45,
            0x13,0x40,0x45,0x19,0x20,0x45,0x1B,0x20,0x45,0x1E,0x40,0x45,0xAA,0x40,0x46,0xCA,
            0x40,0x47,0x6A,0x40,0x47,0x6E,0x10,0x46,0x73,0x20,0x46,0x78,0x20,0x46,0x7E,0x40,
            0x46,0xC4,0x40,0xFF
                                                     };

    static const unsigned char guide_from_2_to_3[] = {0x44,0x87,0x80,0x44,0x8F,0x10,0x45,0x27,0x80,0x45,
            0x2C,0x10,0x45,0x4F,0x80,0x44,0xB3,0x80,0x45,0x13,0x80,0x45,0x19,0x80,0x45,0x1B,
            0x80,0x45,0x1E,0x10,0x45,0xAA,0x80,0x46,0xCA,0x10,0x47,0x6A,0x80,0x47,0x6E,0x10,
            0x46,0x73,0x20,0x46,0x78,0x20,0x46,0x7E,0x80,0xFF
                                                     };

    static const unsigned char guide_from_3_to_2[] = {
         //0x46,0xC4,0x20,  // this one refers to screen 2: probably a bug in the original game data
            0x48,0xE4,0x20,
            0x48,0x87,0x20,
            0x48,0x8B,0x40,
            0x48,0xEB,0x20,
            0x4A,0x27,0x20,
            0x4A,0x2B,0x80,
            0x48,0xF4,0x80,
            0x48,0x94,0x20,
            0x48,0x9B,0x40,
            0x49,0xD1,0x20,
            0x49,0xD4,0x80,
            0x49,0xD7,0x20,
            0x49,0xDB,0x40,
            0x4A,0xE7,0x80,
            0x4A,0xF0,0x80,
            0x4A,0xF7,0x80,
            0x4B,0x47,0x40,
            0x4B,0x53,0x40,
            0xFF };


#endif // GUARDTABLES_H_INCLUDED
