#ifndef STREAM_PROPERTIES_H
#define STREAM_PROPERTIES_H

#include "SysCompat.hpp"
#ifdef _HAS_THREADS
#include "ThreadSafeContainer.hpp"
#endif
#include "Abortable.hpp"

#include <map>

/**
 * input/output stream properties.
 * able to decode/encode numerical formats including
 * integer/float, data size, endian, byteskip, ...
 */

class StreamProperties : public Abortable
{
 public:

    /**
     * utility class for use in child classes but may be used
     * outside them it to ensure
     * atomic send of multiple messages
     */
#ifdef _HAS_THREADS
    class ThreadLock;

    typedef std::map<int,ThreadLock> SemList;
    typedef ThreadSafeContainer<SemList> SemListPool;

    class ThreadLock : public ThreadSafe
    {
    public:
	ThreadLock() : ThreadSafe()
	{}
	static ThreadLock &get_sem(int fd,SemListPool &slp);
    };

#endif

    StreamProperties();

    virtual ~StreamProperties();

    DEF_GET_STRING_TYPE(StreamProperties);

    enum DataFormat { UNDEFINED_FORMAT = 0,
		      I1 = 1,
		      U1 = 1<<1,
		      I2 = 1<<2,
		      U2 = 1<<3,
		      I4 = 1<<4,
		      U4 = 1<<5,
		      R4 = 1<<6};

    enum ByteOrdering { UNDEFINED_ORDERING,
			NATIVE_ORDERING,
			BIG_ENDIAN_ORDERING,
			LITTLE_ENDIAN_ORDERING };
    /**
     * replaces htonl
     */

    static int my_htonl(int n);

    /**
     * tells if swap is required depending on machine endian
     * and current endian property
     */

    bool swap_required() const;

    void set_supported_format_mask(const int format_mask);

    int get_supported_format_mask() const
    {
	return m_supported_format_mask;
    }

    /**
     * @return true if we are running on a big endian CPU
     */

    static bool is_big_endian_architecture();

    /**
     * according to machine architecture, set the default values
     * (real*4, endian of the machine)
     */

    void set_default_output_data_format();

    /**
     * decode the format string
     * @param str string to decode
     *
     * format of str mush match one of the following:
     *
     * <UL>
     * <LI> TYPE (ex: R4, I2)
     * <LI> TYPE_ORDERING (ex: R4_BE, I2_LE)
     * <LI> TYPE_BLOCKSIZE (ex: R4_2048)
     * <LI> TYPE_ORDERING_BLOCKSIZE (ex: R4_BE_1024)
     * </UL>
     */

    void set_data_encoding(const MyString &str);

    /**
     * copy from other stream properties
     */

    void set_properties(const StreamProperties &other);

    /**
     * set stream properties
     */

    void set_properties(DataFormat df,
			ByteOrdering bo = NATIVE_ORDERING,
			int block_size = 1,
			int byte_skip = 0,
			int user_data = 0);

    /**
     * set byte ordering according to the CPU architecture
     * in order to avoid ambiguity for output data */

    void set_explicit_byte_ordering();

    /**
     * just set data format
     */

    void set_data_format(DataFormat df);

    /**
     * just set byte ordering
     */

    void set_byte_ordering(ByteOrdering bo);

    /**
     * get byte ordering
     */

    ByteOrdering get_byte_ordering() const;

    /**
     * just set user data
     */

    void set_user_data_1(const int user_data)
    {
	m_user_data = user_data;
    }

    /**
     * set compound size
     */

    void set_compound_size(const int compound_size)
    {
	m_compound_size = compound_size;
    }

    /**
     * get string version of the properties
     */

    MyString get_data_encoding() const;

    char *get_swapped_copy(const char* bytes, const int bufsize) const;
    void swap_bytes(char* bytes, const int bufsize) const;

    DataFormat get_data_format() const { return m_data_format; }
    int get_block_size() const { return m_block_size; }
    int get_compound_size() const { return m_compound_size; }
    int get_data_size() const { return m_data_size; }
    int get_byte_skip() const { return m_byte_skip; }
    int get_user_data_1() const { return m_user_data; }

    bool is_unsigned_integer_format() const;
    bool is_signed_integer_format() const;
 protected:
    DataFormat m_data_format;
    ByteOrdering m_byte_ordering;
    int m_block_size;   ///< I/O block size
    int m_compound_size; ///< number of gathered items (ex: 2 if complex)
    int m_data_size; ///< size of 1 item
    int m_byte_skip; ///< number of bytes to skip at start of file
    int m_user_data; ///< user data
    int m_supported_format_mask;
 private:
    template <class T>
    static void p_swap_bytes(T *bytes, const int count);
    bool decode_block_size(const MyString &str, int &bs) const;
    bool decode_skip_size(const MyString &str, int &bs) const;
};

#endif
