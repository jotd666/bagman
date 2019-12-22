#ifndef CRC_H
#define CRC_H

/**
 * CRC computing class
 */

class Crc
{
 public:
    /**
     * compute custom crc for data block
     */
    
    static int crc(const int size,const void *data);
};

#endif
