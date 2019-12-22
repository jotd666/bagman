/*---------------------------------------------------------------------------*
 *         (C) 2005  -  THALES Underwater Systems  -  Sophia  -  GSS         *
 *---------------------------------------------------------------------------*/



#ifndef PARAMETERIO_H
#define PARAMETERIO_H


#include "InputStream.hpp"
#include "OutputStream.hpp"
#include "MyString.hpp"
#include "Abortable.hpp"
#include "MyVector.hpp"

#include <list>

class MyStream;
class InputStream;
class OutputStream;

/**
 * parameter file parser
 *
 * @author C. Giuge (original code), C. Le Gentil, JF Fabre
 */
class PrmIo : public Abortable
{

public:
    PrmIo();

    /**
     * opens the file
     */

    PrmIo(const MyString &filename);

    /**
     * maps to an input stream
     */

    PrmIo(InputStream &ifs);

    /**
     * maps to an output stream
     */

    PrmIo(OutputStream &ofs,const MyString & comment = "");
    ~PrmIo();
    DEF_GET_STRING_TYPE(PrmIo);

    /**
     * remind current position
     */

    void store_position();

    /**
     * recall previous stored position
     */

    void restore_position();

    /**
     * open from a file (for reading)
     * @param filename name of the parameter file to open in read mode
     * @param cache_in_mem if true, file will be read in memory first, speeding up operation
     * on slow/uncached filesystems
     */

    void open(const MyString & filename, bool cache_in_mem = true);

    /**
     * open from a file (for writing)
     */

    void create(const MyString & nom_fichier,
                const MyString & comment = "");

    /**
     * close handle
     */

    void close();

    /**
     * write an integer
     */

    void write(const char *ident,int v);

    /**
     * write a real number
     */

    void write(const char *ident,float v,int precision = 10);

    /**
     * write a char array
     */

    void write(const char *ident,const char *v);

    /**
     * write a boolean (yes/no)
     */

    void write(const char *ident,const bool v);

    /**
     * reads a block and checks
     * @param block_name expected block name
     */

    void start_block_verify(const char *block_name);

    /**
     * read a block name amongst a pre-defined list
     *
     * better use the @a READ_BLOCK_NAME macro which computes
     * the list length automatically
     *
     * @param possible_block_names block name list
     * @param nb_types number of items
     */
    int  read_block_name(const char* possible_block_names[],
                         const int   nb_types);

    /**
     * read block name and return the value
     */

    MyString  read_block_name();

    /**
     * read block name macro
     */

#define READ_BLOCK_NAME(block_names) \
    read_block_name(block_names,sizeof(block_names) / sizeof(const char *))

    /**
     * read enum macro
     */
#define READ_ENUM(enum_name,possible_values) \
read_enum(enum_name,possible_values,sizeof(possible_values)/sizeof(char *));

    /**
     * check that the end-of-block delimiter is there
     */

    void end_block_verify();

    // template-style scalar read

    /**
     * @param ident_name key
     * @param value boolean to read
     */

    void read(const char *ident_name,bool &value)
    {
        value = read_boolean(ident_name);
    }

    /**
     * @param ident_name key
     * @param value integer to read
     * @param undefined_allowed if true undefined is OK
     * @param default_value if undefined_allowed, value is set to this
     */

    void read(const char*          ident_name,
              int &value,
              const bool undefined_allowed = false,
              const int default_value = undefined_integer)
    {
        value = read_integer(ident_name,undefined_allowed,default_value);
    }

    /**
     * @param ident_name key
     * @param value long integer to read
     * @param undefined_allowed if true undefined is OK
     * @param default_value if undefined_allowed, value is set to this
     */

    void read(const char*          ident_name,
              long int &value,
              const bool undefined_allowed = false,
              const long int default_value = undefined_integer)
    {
        value = read_integer(ident_name,undefined_allowed,default_value);
    }

    /**
     * @param ident_name key
     * @param value string to read
     * @param undefined_allowed if true undefined is OK
     */

    void read(const char*          ident_name,
              MyString &value,
              const bool undefined_allowed = false)
    {
        value = read_string(ident_name,undefined_allowed);
    }

    /**
     * @param ident_name key
     * @param value float to read
     * @param undefined_allowed if true undefined is OK
     * @param default_value if undefined_allowed, value is set to this
      */

    void read(const char*          ident_name,
              float &value,
              const bool undefined_allowed = false,
              const float default_value = undefined_float)
    {
        value = read_real(ident_name,undefined_allowed,default_value);
    }

    /**
     * read a filename (with env. variable evaluation)
     * @param ident_name key
     * @param undefined_allowed if true undefined is OK
     * @param default_value if undefined_allowed, value is set to this
      */

    MyString read_filename(const char *ident_name,
                           const bool undefined_allowed = false,
                           const char *default_value = NULL);

    // old-style parsing (maybe richer because in some cases there are more
    // possibilities)

    /**
     * read a string
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    MyString read_string(const char*          ident_name,
                         const bool undefined_allowed = false,
                         const char *default_value = NULL);

    /**
     * read an integer
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    int    read_integer(const char*          ident_name,
                        const bool undefined_allowed = false,
                        const int default_value = undefined_integer);

    /**
     * read an integer > 0
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    int    read_index(const char*          ident_name,
                      const bool undefined_allowed = false,
                      const int default_value = undefined_integer);

    /**
     * read an integer >= 0
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    int read_positive_integer(const char*          ident_name,
                              const bool undefined_allowed = false,
                              const int default_value = undefined_integer);

    /**
      * read a float
      * @param ident_name key
      * @param undefined_allowed if true undefined is allowed
      * @param default_value value assumed if undefined found
      */

    float  read_real(const char*          ident_name,
                     const bool undefined_allowed = false,
                     const float default_value = undefined_float);

    /**
     * read a float >= 0
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    float  read_positive_real(const char*          ident_name,
                              const bool undefined_allowed = false,
                              const float default_value = undefined_float);
    /**
     * read a float > 0
     * @param ident_name key
     * @param undefined_allowed if true undefined is allowed
     * @param default_value value assumed if undefined found
     */

    float  read_strictly_positive_real(const char*          ident_name,
                                       const bool undefined_allowed = false,
                                       const float default_value = undefined_float);


    /**
     * read a boolean (yes/no enum)
     */

    bool read_boolean(const char* ident_name);

    /**
     * read an enumerate
     * better use the READ_ENUM macro
     * @return position of the enumerate in the passed list
     */

    int    read_enum(const char* ident_name,
                     const char* noms_types[],
                     const int   nb_types);

    // -- Lecture de vecteurs --

    template <class T>
    void read_vector(MyVector<T> &vecteur,
                     const int nb_elements)
    {
        if ((int)vecteur.size() != nb_elements)
        {
            vecteur.resize(nb_elements);
        }
        read_anonymous_vector(vecteur.raw_data(),nb_elements);
    }

    /**
     * read into list
     */

    template <class T>
    void read(const char *list_name,
              std::list<T> &the_list,
              const int nb_items)
    {
        the_list.clear();
        MyVector<T> items(nb_items);
        read(list_name,items,nb_items);
        for (int i=0;i<nb_items;i++)
        {
            the_list.push_back(items[i]);
        }
    }



    template <class T>
    void read(const char *nom_vecteur,
              MyVector<T> &vecteur,
              const int nb_elements)
    {
        if ((int)vecteur.size() != nb_elements)
        {
            vecteur.resize(nb_elements);
        }

        T *v = (nb_elements > 0) ? vecteur.raw_data() : NULL;


        read_vector(nom_vecteur,v,nb_elements);

    }



    void read(const char *nom_vecteur,
              std::list<MyString> &vecteur,
              const int nb_elements = undefined_integer,
              bool undefined_allowed = true);

    /*D
    *=
    *( ROLE
    *=
    ** Lit un vecteur d'entiers.
    *)
    *( INTERFACE
    *=
    *+ nom_vecteur : entre'e
    ** Nom du vecteur a` lire.
    **
    *+ vecteur : sortie
    ** Vecteur a` lire.
    **
    *+ nb_elements : entre'e
    ** Nombre d'e'le'ments du vecteur a` lire.
    *)
    *( DESCRIPTION
    *=
    ** En cas d'erreur termine par exception et fournit un message \
    ** dans erreur.
    *)
    d*/
    template <class T>
    void read_vector(const char* nom_vecteur,
                     T         vecteur[],
                     const int   nb_elements)
    {
        Mot  mot_lu;

        if ( nom_vecteur != NULL )
        {
            start_block_verify(nom_vecteur);
        }
        ENTRYPOINT(read_vector);

        for (int ind_element = 0; ind_element < nb_elements; ind_element++)
        {
            T &element = vecteur[ind_element];

            // Begin

            read_word(mot_lu,nom_vecteur == NULL ? "a vector" : nom_vecteur);

            if (!decode_scalar(element, mot_lu, false))
            {
                abort_run(get_file_and_line(true));
            }

        }

        end_block_verify();
        EXITPOINT;

    }


    PrmIo &operator>>(float &);
    PrmIo &operator>>(int &);
    PrmIo &operator<<(const char *);
    PrmIo &operator<<(const int);
    PrmIo &operator<<(const float);

    /**
      * read vector without identifier or braces
      */

    template <class T>
    void read_anonymous_vector(MyVector<T> &v, const int   nb_elements)
    {
        v.resize(nb_elements);
        read_anonymous_vector(v.raw_data(),nb_elements);
    }
    /**
     * read vector without identifier or braces
     */

    template <class T>
    void read_anonymous_vector(T v[], const int   nb_elements)
    {
        Mot  mot_lu;

        ENTRYPOINT(read_anonymous_vector);

        for (int ind_element = 0; ind_element < nb_elements; ind_element++)
        {
            T &element = v[ind_element];

            // Begin

            read_word(mot_lu,"anon integer vector");

            if (!decode_scalar(element, mot_lu, false))
            {
                abort_run(get_file_and_line(true));

            }

        }

        end_block_verify();
        EXITPOINT;

    }

    void read_vector(const char*          nom_vecteur,
                     MyString               vecteur[],
                     const int             nb_elements,
                     const bool undefined_allowed = true);


    // -- Ecritures de de'limiteurs de blocs --

    /**
     * write a block start
     * @param block_name name of the block to write
     */

    void start_block_write(const char* block_name);

    /**
     * write a end of block
     */

    void end_block_write();

    /**
     * write a list
     */
    template<class STD_LIST>
    void write(const char *ident_name,const STD_LIST &items)
    {
        typename STD_LIST::const_iterator it;
        indent();
        OutputStream &file = get_output_stream();
        file << "( " << ident_name << " ";

        for (it = items.begin(); it != items.end(); it++)
        {
            file << *it << " ";
        }
        file << ")" << OutputStream::endl;
        ind_ligne++;
    }

    /**
     * write a string
     */

    void write(const char* ident_name,
               const MyString &valeur)
    {
        write(ident_name, valeur.c_str());
    }

    /**
     * @return the actual name of the file being parsed
     * (in case of a stream, the return value is something like "socket stream" ...)
     */

    const MyString &get_filename() const;

    /**
     * @return current line number for the file being parsed/written into
     */

    int    get_line_number() const
    {
        return ind_ligne;
    }


    static const char UNDEFINED_CODE[]; ///< undefined string


    // E must be an enumerate or this is not likely to work

    template <class E>
    void read(const char *enumerate_name,
              const char *type_names[],
              const int nb_types,
              E &result)
    {
        result = (E)read_enum(enumerate_name,type_names,nb_types);
    }

private:

    PrmIo(const PrmIo &);
    PrmIo &operator=(const PrmIo &);

    MyStream *get_stream ()
    {
        return m_handler;
    }


    inline OutputStream &get_output_stream()
    {
        my_assert(m_handler != 0);
        return safe_cast<OutputStream>(m_handler);
    }

    inline InputStream &get_input_stream()
    {
        my_assert(m_handler != 0);
        return safe_cast<InputStream>(m_handler);
    }

    inline bool is_separator(const char c) const
    {
        // spaces, tabs & carriage return chars are accepted

        return (c == CT_SPACE);
    }

    MyString get_file_and_line(bool approx_line = false) const;

    void indent();

    int read_raw_char();
    StreamPosition m_stored_position;
    int            m_stored_line_number;

    enum CharType { CT_START='<',
                    CT_END='>',
                    CT_COMMENT='!',
                    CT_SPACE=' ',
                    CT_QUOTE='"',
                    CT_UNDEFINED='?',
                    CT_LINEFEED='\n',
                    CT_CRYPT=0xa7,
                    CT_OTHER
                  };

    static const int CT_COMMENT_END;

    MyStream   *m_handler;
    const bool m_handler_owned_by_this;
    int          ind_ligne;
    int          m_current_indent;
    int          m_encryption_key;
    int          m_cached_char;
    bool         m_encrypted;
    bool         m_has_cached_char;

    typedef char Mot[256+1]; ///< word cannot exceed this size

    static MyString add_dirname(const MyString & nom_fichier,
                                const MyString & repertoire);

    void write_comment_header(const MyString &comment);
    void destroy_handler();

    void init_members();

    int          read_char();
    bool          read_word(Mot word,const char *word_meaning,bool value_for = false,
                            bool allow_end_block_delimiter = false);
    bool          check_delimitor(const char voulu);

    void         read_scalar(Mot            value,
                             const char*    ident_name,
                             const bool undefined_allowed);

    bool decode_scalar(
        int &valeur,
        const char *chaine,
        bool undefined_allowed,
        const int default_value=undefined_integer) const;

    bool decode_scalar(
        float &valeur,
        const char *chaine,
        bool undefined_allowed,
        const float default_value=undefined_float) const;

    /*  template <class T>
      static bool decode_scalar(
          T &valeur,
          const char *chaine,
          bool undefined_allowed)
      {
          return decode_scalar(valeur,chaine,undefined_allowed,get_default_value(valeur));
      }*/

    static inline float get_default_value(const float)
    {
        return undefined_float;
    }
    static inline int get_default_value(const int)
    {
        return undefined_integer;
    }

    static const char	m_start_block_delimiter;
    static const char	m_end_block_delimiter;
    static const char	m_comment_start;
    static const char	m_comment_end;

    static const char	m_end_of_line;
    static const char	m_space;

};


#endif


