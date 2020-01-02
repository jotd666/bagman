/*---------------------------------------------------------------------------*
 *         (C) 2005  -  JFF Software         *
 *---------------------------------------------------------------------------*/


/**
 * @author C Giuge, C Le Gentil, JF Fabre
 */

// JFF: gcc 2.95.2 "hack" to recognize strcasecmp

#if (defined __GNUC__ && __GNUC__ == 2)
#define __EXTENSIONS__
#include <string.h>
#endif

#ifdef _WIN32
#define strcasecmp stricmp
#endif


#undef NDEBUG_TRACE  // never print traces

#include "FileInputStream.hpp"
#include "FileOutputStream.hpp"
#include "BufferInputStream.hpp"
//#include "../../GsVersion.H"
#include "PrmIo.hpp"

#include "GsDefine.hpp"
#include "GsTime.hpp"
#include "MyFile.hpp"

#include <cerrno> // to detect EINTR
#include <stdlib.h>

using namespace std;


const int PrmIo::CT_COMMENT_END = PrmIo::CT_LINEFEED;

const char	PrmIo::UNDEFINED_CODE[]	        = {PrmIo::CT_UNDEFINED,'\0'};


static const MyString undefined_code = PrmIo::UNDEFINED_CODE;

static const int indent_step = 2;

#define endl OutputStream::endl

#define DECL_OUT_FILE OutputStream &fichier = get_output_stream()

#define COMPARE_TO_UNDEFINED(c) strcmp(c,UNDEFINED_CODE)

static inline bool string_to_int(const char *v, int &iv)
{

  iv = atoi(v); // temporary, could be improved, but at least it's super fast
  return true;
}
/*************************
  Role  : read a significant digit
  Return: read digit
  Description:
   Un espace est un des caracte`res `` '', ``\t'' ou ``\n''.
   Si l'on renconte une fin de ligne, on incremente le nume'ro de ligne.
   Si l'on recontre un de'but de commentaire, on saute jusqu'apre's la fin du  commentaire.
   Si l'on renconte une serie d'espaces on renvoie un espace
   Si l'on renconte une fin de fichier, elle est renvoye'e.
   Sinon on renvoie le caracte`re lu.

  **************************/
inline int PrmIo::read_char()
{
  int caractere;
  int dans_commentaire	= 0;
  int dans_espaces		= 0;
  int dans_retours            = 0;

  while ((caractere = read_raw_char()) != EOF)
    {
      if (caractere == CT_LINEFEED) ind_ligne++;

      if (dans_commentaire)
	{
	  if (caractere ==  CT_COMMENT_END)
	    {
	      dans_commentaire = 0;
	    }
	  continue;
	}

      if (dans_espaces)
	{
	  switch (caractere)
	    {
	      case CT_LINEFEED:
		dans_retours = 1;
	      case CT_SPACE:
		break;

	      case CT_COMMENT:
		dans_commentaire = 1;
		break;

	      default:
		// removed need for backward seek, putback...
		m_has_cached_char = true;
		m_cached_char = caractere;

		return CT_SPACE;
		break;
	    }
	}
      else
	{
	  switch (caractere)
	    {
	      case CT_LINEFEED:
		dans_retours = 1;
		dans_espaces = 1;
		break;
	      case CT_SPACE:
		dans_espaces = 1;
		break;
	      case CT_COMMENT:
		dans_commentaire = 1;
		break;

	      default:
		return caractere;
		break;
	    }
	}
    }

  return (((dans_espaces) && (caractere != EOF)) || (dans_retours)) ? CT_SPACE : EOF;
}


/*************************
  Role  : read a significant digit
  Return: bool for success or not
  Description:
  Un mot est une suite de caracte`res autre que les espaces, le caracte`re \
  de'but de commentaire et les de'limiteurs de bloc.
  Retourner la suite des caracte`res trouve's jusqu'au prochain se'parateur.
  Ve'rifier que le mot est suivi d'un se'parateur.
  En cas d'erreur renvoie un mot vide et \
  fournit un message dans Erreur:erreur.

  **************************/
bool PrmIo::read_word(Mot mot, const char *word_meaning,
		      const bool value_for,
		      const bool allow_end_block_delimiter)
{
  bool end_with_end_delimiter = false;
  ENTRYPOINT(read_word);

  int  caractere;
  int  nb_caracteres = 0;
  bool within_quote = false;
  bool end_read = false;

  while ((!end_read) && ((caractere = read_char()) != EOF))
    {
      if (nb_caracteres > 0)
	{
	  bool add_char = false;

	  switch (caractere)
	    {
	      case CT_START:
	      case CT_END:
		if (!within_quote)
		  {
		    abort_run("%s block delimiter found while reading%s %q,%s",
			      caractere == CT_START ? "start" : "end",
			      value_for ? " value for" : "",word_meaning,get_file_and_line());
		  }
		else
		  {
		    add_char = true;
		  }

		break;
	      case CT_QUOTE:
		within_quote = !within_quote;
		break;
	      default:
		if (is_separator(caractere) && (!within_quote))
		  {
		    // end of word found, successful end
		    mot[nb_caracteres] = '\0';
		    end_read = true;
		  }

		else
		  {
		    add_char = true;
		  }


		break;
	    }
	  if (add_char)
	    {
	      if (nb_caracteres < (int)sizeof(Mot)-1)
		{
		  mot[nb_caracteres] = caractere;
		  nb_caracteres++;
		}
	      else
		{
		  mot[nb_caracteres] = '\0';
		  abort_run("word too long%s, while reading %s, read %q",
			    get_file_and_line(),word_meaning,mot);
		}
	    }

	}
      else // nb_caracteres == 0
	{
	  if ((is_separator(caractere) && (!within_quote)))
	    {
	      abort_run("blank found while reading %s,%s",word_meaning,get_file_and_line());
	    }
	  switch (caractere)
	    {
	      case CT_QUOTE:
		within_quote = !within_quote;
		break;
	      case CT_START:
	      case CT_END:
		if (allow_end_block_delimiter && caractere == CT_END)
		  {
		    end_with_end_delimiter = true;
		    // end of word found, successful end
		    mot[nb_caracteres] = '\0';
		    end_read = true;
		  }
		else
		  {
		    abort_run("two block delimiters in a row while reading %s,%s",
			      word_meaning,get_file_and_line());
		  }
		break;

	      default:
		mot[nb_caracteres] = caractere;
		nb_caracteres++;
		break;
	    }
	}
    }
  if (!end_read)
    {
      abort_run("syntax error, end of file %q encountered", get_filename());
    }


  EXITPOINT;
  return end_with_end_delimiter;
}

// removed istringstream usage here, this caused a lot of problems with Nintendo DS.
// back to basics => much better

bool PrmIo::decode_scalar(
			  int &valeur,
			  const char *chaine,
			  bool undefined_allowed,
			  const int default_value) const
{
  bool rval = true;
  ENTRYPOINT(decode_scalar);
  valeur = default_value;

  if (COMPARE_TO_UNDEFINED(chaine) == 0)
    {
      rval = undefined_allowed;
    }
  else
    {
      rval = string_to_int(chaine,valeur);
    }
  EXITPOINT;
  return rval;

}
bool PrmIo::decode_scalar(
			  float &valeur,
			  const char *chaine,
			  bool undefined_allowed,
			  const float default_value) const
{
  bool rval = true;
  ENTRYPOINT(decode_scalar);
  valeur = default_value;

  if (COMPARE_TO_UNDEFINED(chaine) == 0)
    {
      rval = undefined_allowed;
    }
  else
    {
      valeur = atoi(chaine);
      rval = true; // TODO: check if 0
    }
  EXITPOINT;
  return rval;
}



/*D
 *=
 *( ROLE
 *=
 ** Lit et ve'rifie un caracte`re "de'limiteur".
 *)
 *( INTERFACE
 *=
 *+ voulu : entre'e
 ** De'limiteur voulu.
 **
 *+ Retourne : sortie
 *)
 *( DESCRIPTION
 *=
 ** Sauter un e'ventuel se'parateur de te^te.
 ** Ve'rifier que l'on trouve alors le de'limiteur voulu, \
 ** puis ve'rifier que ce de'limiteur est bien suivi par un se'parateur
 ** En cas d'erreur, fournit un message dans erreur.
 *)
  d*/
bool PrmIo::check_delimitor(const char voulu)
{
  int  caractere;
  bool rval = false;

  // -- Sauter un e'ventuel se'parateur --

  caractere = read_char();

  if (is_separator(caractere))
    {
      caractere = read_char();
    }

  if (caractere == voulu)
    {
      // -- Verifier caractere suivant est un separateur --

      caractere = read_char();

      if (is_separator(caractere))
	{
	  /* OK */

	  rval = true;
	}
    }

  return rval;
}


/*D
 *=
 *( ROLE
 *=
 ** Lit un parame`tre scalaire.
 *)
 *( INTERFACE
 *=
 *+ valeur : sortie
 ** Chaine lue.
 **
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire ou NULL.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 *)
 *( DESCRIPTION
 *=
 ** Lit le fichier et ve'rifie que l'on trouve bien :
 ** - un de'limiteur de de'but de bloc,
 ** - un mot qui doit e^tre nom_scalaire,
 ** - un mot qui lu pour valeur,
 ** - un de'limiteur de fin de bloc,
 **
 ** Si undefined_allowed, la chaine lue peut e^tre indefinie, \
 ** c'est a` dire e'gale a` UNDEFINED_CODE.
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *  return valeur
 *)
  d*/
void PrmIo::read_scalar(Mot valeur,
			const char*    nom_scalaire,
			const bool undefined_allowed)
{
  Mot nom_bloc;
  ENTRYPOINT(read_scalar);

  if (nom_scalaire != NULL)
    {
      if (!check_delimitor(CT_START))
	{

	  abort_run("initial block delimiter error%s "
		    "(while reading scalar %q)",
		    get_file_and_line(), nom_scalaire);

	}


      read_word(nom_bloc,nom_scalaire);

      if (strcasecmp(nom_bloc, nom_scalaire) != 0)
	{
	  // -- Mauvais nom de bloc --
	  abort_run("%q read instead of %q%s",
		    nom_bloc, nom_scalaire,  get_file_and_line());

	}
    }

  read_word(valeur,nom_scalaire,true);

  if (!check_delimitor(CT_END))
    {
      abort_run("end block delimiter error"+get_file_and_line());
    }


  if (COMPARE_TO_UNDEFINED(valeur) == 0 && undefined_allowed == false)
    {
      if (nom_scalaire != 0)
	{
	  abort_run("undefined code read for scalar %q%s",
		    nom_scalaire , get_file_and_line());
	}
      else
	{
	  abort_run("unvalid undefined code %s read%s",
		    nom_scalaire , get_file_and_line());
	}

    }
  EXITPOINT;
}


/*---------------------*
 * Fonctions visibles. *
 *---------------------*/

/*D
 *=
 *( ROLE
 *=
 ** Constructeur.
 *)
 *( INTERFACE
 *=
 *)
 *( DESCRIPTION
 *=
 *)
  d*/

void PrmIo::init_members()
{
  m_stored_line_number = -1;
  ind_ligne = -1;
  m_encrypted = false;
  m_encryption_key = 0;
  m_current_indent = 0;
  m_stored_position = 0;
  m_cached_char = 0;
  m_has_cached_char = false;
}


PrmIo::PrmIo() : Abortable("PrmIo"),
m_handler(0),
m_handler_owned_by_this(true)
{
  init_members();
}

PrmIo::PrmIo(const MyString &filename) : Abortable(filename),
m_handler(0),
m_handler_owned_by_this(true)
{
  open(filename);
}

PrmIo::~PrmIo()
{
  destroy_handler();
}


PrmIo::PrmIo(InputStream &ifs)
: Abortable("Streamed Input PrmIo"),
m_handler(&ifs),
m_handler_owned_by_this(false)
{
  init_members();
}

PrmIo::PrmIo(OutputStream &ofs,const MyString & comment)
: Abortable("Streamed Output PrmIo"),
m_handler(&ofs),
m_handler_owned_by_this(false)
{
  init_members();

  write_comment_header(comment);
}

const MyString &PrmIo::get_filename() const
{
  return (m_handler == 0) ? undefined_code : m_handler->get_name();
}

/*D
 *=
 *( ROLE
 *=
 ** Ouvre un fichier de parame`tres en lecture.
 *)
 *( INTERFACE
 *=
 *+ nom_fichier : entre'e
 ** Nom du fichier a` ouvrir.
 *)
 *( DESCRIPTION
 *=
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
void PrmIo::open(const MyString &filename, bool cache_in_memory)
{
  ENTRYPOINT(open);

  // identify object
  set_name(filename);

  MyFile fobj(filename);

  init_members();

  if (m_handler != 0)
    {
      abort_run("Descriptor already in use");
    }

  InternalInputStream *fis;

  if (cache_in_memory)
    {
      // raed fully
      StreamSize size;
      const char *contents = (const char *)fobj.read_all(size);
      // map the memory on the buffer
      LOGGED_NEW(fis,BufferInputStream(contents,size,BufferInputStream::MODE_STEAL));
    }
  else
    {
      // don't cache
      LOGGED_NEW(fis,FileInputStream(filename));
    }
  LOGGED_NEW(m_handler,InputStream(fis));

  if (m_handler->fail())
    {
      abort_run("Cannot open file %q, %s",
		get_filename(),
		system_error_reason());
    }

  ind_ligne = 1;

  // check if file has encrypted format

  unsigned char c = read_raw_char();

  // encrypted if starts by crypt header char

  m_encrypted = (c == CT_CRYPT);

  if (m_encrypted)
    {
      // compute seed
      StreamSize sz = fobj.size();

      m_encryption_key = sz % 0x1f;
    }
  else
    {
      // kind of rewind without actually rewinding
      m_has_cached_char = true;
      m_cached_char = c;
    }
  // from now on read_raw_char return decrypted chars if m_encrypted is set

  EXITPOINT;
}

inline int PrmIo::read_raw_char()
{
  int c;
  bool was_cached = m_has_cached_char;

  if (was_cached)
    {
      c = (unsigned char)m_cached_char;
      m_has_cached_char = false;
    }
  else
    {
      c = (unsigned char)get_input_stream().get();
    }

  // decrypt only if the conditions below are OK:
  //
  // - char was not in cache (already decrypted)
  // - encryption is on
  // - char is not a control or EOF char

  if ((m_encrypted) && (!was_cached)  &&
      (c != (unsigned char)EOF) && (c >= ' '))
    {
      int c_low;

      c -= ' '; /* 0 -> 0x5f */

      c_low = c & 0x1f;

      c_low ^= m_encryption_key;

      c = (c & 0x60) | (c_low & 0x1f);

      c += ' '; /* 0x20 -> 0x7f */

      m_encryption_key = (m_encryption_key + 0x23) % 0x1f;
    }

  // all non-ascii characters except linefeed are considered as spaces

  if ((c != (unsigned char)EOF) && (c != CT_LINEFEED) &&
      (c != CT_CRYPT) && ((c<0x20)||(c>0x7f)))
    {
      c = CT_SPACE;
    }


  return c;
}


/*D
 *=
 *( ROLE
 *=
 ** Cre'e en e'criture un fichier de parame`tres en lecture.
 *)
 *( INTERFACE
 *=
 *+ nom_fichier : entre'e
 ** Nom du fichier a` ouvrir.
 **
 *+ commentaire : entre'e
 ** Commentaire.
 *)
 *( DESCRIPTION
 *=
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
void PrmIo::create(const MyString & nom_fichier,
		   const MyString & comment)
{

  ENTRYPOINT(create);

  bool skip_write = false;

  if (m_handler != 0)
    {
      abort_run("Descriptor already in use");
    }

  FileOutputStream *fos;
  LOGGED_NEW(fos,FileOutputStream(nom_fichier));
  LOGGED_NEW(m_handler, OutputStream(fos));

  if (m_handler->fail())
    {
      if (errno == EINTR )
	{
	  warn("interrupted system call while creating %q",nom_fichier);
	  skip_write = true;
	  destroy_handler();
	}
      else
	{
	  abort_run("impossible to create file %q, %s",
		    nom_fichier, system_error_reason());
	}
    }

  // identify the object

  set_name(nom_fichier);

  if (!skip_write)
    {
      write_comment_header(comment);
    }
  EXITPOINT;
}

void PrmIo::write_comment_header(const MyString &comment)
{
  DECL_OUT_FILE;
  static const MyString current_date = GsTime::get_current_date();
  //static const MyString host_name = GsHost().get_host_name();

 // fichier.setf(ios::showpoint);

  if (comment != "")
    {
      fichier << "! " << comment << endl;
    }
  //fichier << endl << "! Version " << GsVersion::get() << " linked on " <<
  // GsVersion::date() << endl;
  //fichier << "! File created on " << current_date << " on host " << host_name
  //    << endl;
  ind_ligne = 2;
}


void PrmIo::close()
{
  ENTRYPOINT(close);
  if (!m_handler_owned_by_this)
    {
      warn("attempting to close a stream handler"
	   " not owned by this object");
    }
  else
    {
      destroy_handler();
    }
  EXITPOINT;
}





/*D
 *=
 *( ROLE
 *=
 ** Lit et ve'rifie une structure de de'but de bloc.
 *)
 *( INTERFACE
 *=
 *+ nom_bloc : entre'e
 ** Nom du bloc a` ve'rifier.
 *)
 *( DESCRIPTION
 *=
 ** Lit le fichier et ve'rifie que l'on trouve bien un \
 ** de'limiteur de de'but de bloc suivi du mot nom_bloc.
 ** Si nom_bloc = 0 alors rien n'est fait.
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
void PrmIo::start_block_verify(const char *nom_bloc)
{
  Mot   nom_lu;
  ENTRYPOINT(start_block_verify);

  if (nom_bloc != NULL)
    {
      if (!check_delimitor(CT_START))
	{
	  abort_run("initial block delimiter error for %q%s",
		    nom_bloc,  get_file_and_line());
	}

      read_word(nom_lu,nom_bloc);

      if (strcasecmp(nom_bloc, nom_lu) != 0)
	{
	  abort_run("read %q instead of %q%s",
		    nom_lu, nom_bloc,get_file_and_line());
	}
    }
  EXITPOINT;

}
MyString PrmIo::read_block_name()
{
  Mot   nom_lu;
  ENTRYPOINT(read_block_name);

  if (!check_delimitor(CT_START))
    {
      abort_run("initial block delimiter error %s",
		get_file_and_line());
    }

  read_word(nom_lu,"any block name");


  EXITPOINT;

  return(MyString(nom_lu));
}
MyString PrmIo::get_file_and_line(bool approx_line) const
{
  my_assert(m_handler != 0);

  if (m_encrypted)
    {
      // do not let the tokens nor line numbers appear
      abort_run("syntax error in file %q",get_filename());
    }

  return (" in file \""+get_filename()+MyString("\", ")+
	  (approx_line ? "near line " : "line ")+MyString(ind_ligne)+
	  ", pos "+MyString((int)(safe_cast<InputStream>(m_handler).tellg())));
}

/*D
 *=
 *( ROLE
 *=
 ** Lit un nom de bloc parmi un des noms possibles.
 *)
 *( INTERFACE
 *=
 *+ noms_types, nb_types : entre'e
 ** Nom des types de bloc.
 **
 *+ Retourne : sortie
 ** Indice du nom de bloc.
 *)
 *( DESCRIPTION
 *=
 ** Lit le fichier et ve'rifie que l'on trouve bien un \
 ** de'limiteur de de'but de bloc suivi d'un nom de bloc valide.
 ** Retourne l'indice du nom de bloc.
 ** En cas d'erreur termine par exception et fournit un message dans \
 ** erreur.
 *)
  d*/
int PrmIo::read_block_name(const char* noms_types[],
			   const int   nb_types)
{
  Mot nom_lu;
  int	i;
  int rval = 0;
  ENTRYPOINT(read_block_name);

  if (!check_delimitor(CT_START))
    {
      abort_run("initial block delimiter error"+get_file_and_line());
    }


  read_word(nom_lu,"a block name");


  for (i = 0; i < nb_types; i++)
    {
      if (strcasecmp(nom_lu, noms_types[i]) == 0) break;
    }

  if (i < nb_types)
    {
      rval = i;
    }
  else
    {
      MyString msg;
      static const MyString quotes("\""),coma(",");

      for (i = 0;  i < nb_types;  i++)
	{
	  if (i>0) msg += coma;
	  msg += quotes + noms_types[i] + quotes;
	}
      abort_run("block name read %q"
		" doesn't match one of the %d following: "+msg+
		get_file_and_line(),nom_lu, nb_types);
    }
  EXITPOINT;
  return rval;

}


/*D
 *=
 *( ROLE
 *=
 ** Lit et ve'rifie une structure de fin de bloc.
 *)
 *( INTERFACE
 *=
 *+ nom_bloc : entre'e
 ** Nom du bloc a` ve'rifier.
 *)
 *( DESCRIPTION
 *=
 ** Lit le fichier et ve'rifie que l'on trouve bien \
 ** un de'limiteur de fin de bloc.
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
void PrmIo::end_block_verify()
{

  ENTRYPOINT(end_block_verify);


  if (!check_delimitor(CT_END))
    {
      abort_run("missing '%c' or newline"+get_file_and_line(),(char)CT_END);
    }

  EXITPOINT;
}


// -- Lecture de scalaires --
/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire de type chaine de carate`res.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 **
 *+ Retourne : sortie
 ** Valeur du scalaire lu.
 *)
 *( DESCRIPTION
 *=
 ** Si undefined_allowed et si la chaine lue est indefinie, \
 ** alors renvoie une chaine indefinie.
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
MyString PrmIo::read_string(const char*          nom_scalaire,
			    const bool undefined_allowed,
			    const char *default_value)
{
  Mot  mot_lu;

  read_scalar(mot_lu, nom_scalaire, undefined_allowed);

  if (!strcmp(mot_lu,UNDEFINED_CODE) && default_value != NULL)
    {
      strcpy(mot_lu,default_value);
    }
  return mot_lu;

}



/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire de type entier.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 **
 *+ Retourne : sortie
 ** Valeur du scalaire lu.
 *)
 *( DESCRIPTION
 *=
 ** Le nume'rique doit correspondre strictement au type entier \
 ** (ne doit pas e^tre suivi d'autres caracte`res).
 ** Si undefined_allowed et si la chaine lue est indefinie, \
 ** alors renvoie undefined_integer.
 ** En cas d'erreur termine par exception et fournit un message \
 ** dans erreur.
 *)
  d*/
int PrmIo::read_integer(const char*          nom_scalaire,
			const bool   undefined_allowed,
			const int default_value)
{
  Mot    mot_lu;
  int    valeur;

  ENTRYPOINT(read_integer);

  read_scalar(mot_lu, nom_scalaire, undefined_allowed);

  if (!decode_scalar(valeur, mot_lu, undefined_allowed, default_value))
    {
      abort_run("Unexpected data type when reading %q%s",
		nom_scalaire,  get_file_and_line());
    }

  EXITPOINT;
  return valeur;
}

/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire de type entier strictement positif.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 **
 *+ Retourne : sortie
 ** Valeur du scalaire lu.
 *)
 *( DESCRIPTION
 *=
 ** Le nume'rique doit correspondre strictement au type entier > 0 \
 ** (ne doit pas e^tre suivi d'autres caracte`res).
 ** Si undefined_allowed et si la chaine lue est indefinie, \
 ** alors renvoie undefined_integer.
 ** En cas d'erreur termine par exception et fournit un message \
 ** dans erreur.
 *)
  d*/
int PrmIo::read_index(const char*          nom_scalaire,
		      const bool undefined_allowed,
		      const int default_value)
{

  int cr = 0;
  ENTRYPOINT(read_index);
  cr = read_integer(nom_scalaire, undefined_allowed, default_value);

  if ( cr <= 0 )
    {
      abort_run("Value must be > 0 (found %d) when reading %q%s",
		cr, nom_scalaire,  get_file_and_line());

    }
  EXITPOINT;

  return (cr);
}

int PrmIo::read_positive_integer(const char*          nom_scalaire,
				 const bool undefined_allowed,const int default_value)
{

  int value = 0;
  ENTRYPOINT(read_positive_integer);
  value = read_integer(nom_scalaire, undefined_allowed, default_value);

  if (( value < 0 ) && ( value != undefined_integer))
    {
      abort_run("Value must be >= 0 (found %d) when reading %q%s",
		value, nom_scalaire,  get_file_and_line());

    }
  EXITPOINT;

  return (value);
}

float PrmIo::read_positive_real(const char*          nom_scalaire,
				const bool undefined_allowed,
				const float default_value)
{
  float rval = 0.0;
  ENTRYPOINT(read_positive_real);
  rval = read_real(nom_scalaire,undefined_allowed,default_value);

  if ((rval < 0.0) && (is_not_undefined_float(rval)))
    {
      abort_run("value of %q cannot be < 0, found %f,%s",
		nom_scalaire,rval,get_file_and_line());
    }
  EXITPOINT;
  return rval;
}
float PrmIo::read_strictly_positive_real(const char*          nom_scalaire,
					 const bool undefined_allowed,
					 const float default_value)
{
  float rval = 0.0;
  ENTRYPOINT(read_strictly_positive_real);
  rval = read_real(nom_scalaire,undefined_allowed,default_value);

  if ((rval <= 0.0) && (is_not_undefined_float(rval)))
    {
      abort_run("value of %q must be > 0, found %f,%s",
		nom_scalaire,rval,get_file_and_line());
    }
  EXITPOINT;
  return rval;
}

/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire de type re'el.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 **
 *+ Retourne : sortie
 ** Valeur du scalaire lu.
 *)
 *( DESCRIPTION
 *=
 ** Le nume'rique doit correspondre strictement au type re'el \
 ** (ne doit pas e^tre suivi d'autres caracte`res).
 ** Si undefined_allowed et si la chaine lue est indefinie, \
 ** alors renvoie undefined_float.
 ** En cas d'erreur termine par exception et fournit un message \
 ** dans erreur.
 *)
  d*/
float PrmIo::read_real(const char*          nom_scalaire,
		       const bool undefined_allowed,
		       const float default_value)
{
  Mot   mot_lu;
  float valeur;
  ENTRYPOINT(read_real);

  read_scalar(mot_lu, nom_scalaire, undefined_allowed);

  if (!decode_scalar(valeur, mot_lu, undefined_allowed,default_value))
    {
      abort_run("incorrect float value found when reading %q%s",
		nom_scalaire,  get_file_and_line());
    }
  EXITPOINT;

  return valeur;
}


/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire boole'en.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ Retourne : sortie
 ** Valeur du scalaire lu, oui = 1, non = 0.
 *)
 *( DESCRIPTION
 *=
 ** Les valeurs possibles sont "oui" ou "non".
 ** En cas d'erreur termine par exception et fournit un message \
 ** dans erreur.
 *)
  d*/
bool PrmIo::read_boolean(const char* nom_scalaire)
{
  Mot mot_lu;
  bool rval=false;
  ENTRYPOINT(read_boolean);

  read_scalar(mot_lu, nom_scalaire, false);

  if (strcasecmp(mot_lu, "yes") == 0)
    {
      rval = true;
    }
  else if (!(strcasecmp(mot_lu, "no") == 0))
    {
      abort_run("boolean value must be yes/no"
		"when reading %q,%s (read %s)",
		nom_scalaire,  get_file_and_line(),mot_lu);
    }
  EXITPOINT;

  return rval;
}


/*D
 *=
 *( ROLE
 *=
 ** Lit un scalaire de type e'nume're'.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire a` lire.
 ** Si NULL le nom du scalaire a` de'ja` e'te' lu par LisTypeBloc.
 **
 *+ noms_types : entre'e
 ** Liste des diffe'rentes chai^nes possibles.
 **
 *+ nb_types : entre'e
 ** Nombre de chai^nes possibles.
 **
 *+ Retourne : sortie
 ** Indice de la chaine lue parmis les diffe'rentes chaines \
 ** possibles.
 *)
 *( DESCRIPTION
 *=
 ** En cas d'erreur termine par exception et fournit un message dans \
 ** erreur.
 *)
  d*/
int PrmIo::read_enum(const char* nom_scalaire,
		     const char* noms_types[],
		     const int   nb_types)
{
  Mot    mot_lu;
  int	   indice;

  read_scalar(mot_lu, nom_scalaire, false);

  ENTRYPOINT(read_enum);

  for (indice = 0; indice < nb_types; indice++)
    {
      if (strcasecmp(mot_lu, noms_types[indice]) == 0)
	{
	  break;
	}
    }

  if (indice >= nb_types)
    {
      abort_run("Value %q for scalar %q%s"
		" is not a possible value\n"
		"Allowed values are: %s",
		mot_lu, nom_scalaire,
		get_file_and_line(true),
		MyString(noms_types,'"','"','\n',nb_types));
    }
  EXITPOINT;

  return indice;
}


/*D
 *=
 *( ROLE
 *=
 ** Un nom de fichier absolu (commenc~ant par /) est retourne' tel quel.
 ** Un nom de fichier relatif est concate'ne' au nom de re'pertoire.
 *)
 *( INTERFACE
 *=
 *+ nom_fichier, repertoire : entre'e
 ** Nom de fichier et re'pertoire. Les deux peuvent e^tre indefinis.
 **
 *+ Retourne : sortie
 ** Nom complet.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
MyString PrmIo::add_dirname(const MyString & nom_fichier,
			    const MyString & repertoire)
{

  MyString rval(nom_fichier);

  if (nom_fichier.length() > 0)
    {

      if (repertoire.length() > 0)
	{


	  if (nom_fichier[0] != '/')
	    {

	      // Begin

	      rval = repertoire/nom_fichier;
	    }
	}
    }

  return rval;

}


// -- Lecture de vecteurs --





/*D
 *=
 *( ROLE
 *=
 ** Lit un vecteur de chaines de carate`res.
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
 **
 *+ undefined_allowed : entre'e
 ** Indicateur de code indefini valide.
 ** Si oui chacun des e'le'ments pourra e^tre indefini.
 *)
 *( DESCRIPTION
 *=
 ** En cas d'erreur termine par exception et fournit un message dans erreur.
 *)
  d*/
void PrmIo::read_vector(const char*          nom_vecteur,
			MyString               vecteur[],
			const int             nb_elements,
			const bool undefined_allowed)
{
  Mot  mot_lu;
  int  ind_element;

  ENTRYPOINT(read_vector<string>);
  start_block_verify(nom_vecteur);

  for (ind_element = 0; ind_element < nb_elements; ind_element++)
    {
      MyString & element = vecteur[ind_element];

      read_word(mot_lu,nom_vecteur);

      if (COMPARE_TO_UNDEFINED(mot_lu) == 0)
	{
	  if (undefined_allowed)
	    {
	      element = PrmIo::UNDEFINED_CODE;
	    }
	  else
	    {
	      if (nom_vecteur != 0)
		{
		  abort_run("undefined code not valid for vector %q%s",
			    nom_vecteur, get_file_and_line(true));
		}
	      else
		{
		  abort_run("undefined code not valid"+get_file_and_line(true));
		}

	    }
	}
      else
	{
	  element = MyString(mot_lu);
	}
    }

  end_block_verify();
  EXITPOINT;

}



// -- Ve'rification de scalaires --



// -- Ecritures --
/*D
 *=
 *( ROLE
 *=
 ** Ecrit un de'but de bloc.
 *)
 *( INTERFACE
 *=
 *+ nom_bloc : entre'e
 ** Nom de bloc.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
void PrmIo::start_block_write(const char* nom_bloc)
{

  DECL_OUT_FILE;

  indent();
  fichier << char(CT_START) << " " << nom_bloc << endl;
  m_current_indent+=indent_step;
  ind_ligne++;
}


/*D
 *=
 *( ROLE
 *=
 ** Ecrit une fin de bloc.
 *)
 *( INTERFACE
 *=
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
void PrmIo::end_block_write()
{
  DECL_OUT_FILE;

  m_current_indent-=indent_step;

  indent();
  fichier << char(CT_END) << endl;
  ind_ligne++;
}


/*D
 *=
 *( ROLE
 *=
 ** Ecrit une chaine.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire.
 **
 *+ valeur : entre'e
 ** Valeur.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
void PrmIo::write(const char* nom_scalaire,
		  const char* valeur)
{

  DECL_OUT_FILE;
  indent();
  fichier << char(CT_START) << " " << nom_scalaire << " ";
  if (valeur == NULL)
    {
      fichier << "?";
    }
  else
    {
      fichier << valeur;
    }
  fichier << " " << char(CT_END) << endl;
  ind_ligne++;
}


/*void PrmIo::writeString (const char* str){
    DECL_OUT_FILE;
   fichier << str << endl;
   ind_ligne++;
   }*/


/*D
 *=
 *( ROLE
 *=
 ** Ecrit un entier.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire.
 **
 *+ valeur : entre'e
 ** Valeur.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
void PrmIo::write(const char* nom_scalaire,
		  const int   valeur)
{
  DECL_OUT_FILE;
  indent();
  fichier << char(CT_START) << " " << nom_scalaire << " ";
  if (valeur == undefined_integer)
    {
      fichier << "?";
    }
  else
    {
      fichier << valeur;
    }
  fichier << " " << char(CT_END) << endl;
  ind_ligne++;
}


/*D
 *=
 *( ROLE
 *=
 ** Ecrit un re'el.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire.
 **
 *+ valeur : entre'e
 ** Valeur.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/

void PrmIo::write(const char* nom_scalaire,
		  const float valeur,
		  const int precision)
{
  DECL_OUT_FILE;
  indent();
  fichier << char(CT_START) << " " << nom_scalaire << " ";
  if (is_undefined_float(valeur))
    {
      fichier << "?";
    }
  else
    {
      fichier.setprecision(precision);
      fichier << valeur;
      //fichier << setprecision(precision) << valeur;
    }
  fichier << " " << char(CT_END) << endl;

  ind_ligne++;


}


/*D
 *=
 *( ROLE
 *=
 ** Ecrit un boole'en.
 *)
 *( INTERFACE
 *=
 *+ nom_scalaire : entre'e
 ** Nom du scalaire.
 **
 *+ valeur : entre'e
 ** Valeur.
 *)
 *( DESCRIPTION
 *=
 *)
  d*/
void PrmIo::write(const char* nom_scalaire,
		  const bool   valeur)
{
  DECL_OUT_FILE;
  indent();
  fichier << char(CT_START) << " " << nom_scalaire << " ";
  if (valeur)
    {
      fichier << "yes";
    }
  else
    {
      fichier << "no";
    }
  fichier << " " << char(CT_END) << endl;
  ind_ligne++;

}

#if 0
/*D
*=
*( ROLE
*=
** Ecrit un vecteur de chai^nes.
*)
*( INTERFACE
*=
*+ nom_vecteur : entre'e
** Nom du vecteur.
**
*+ vecteur, nb_elements : entre'e
** Vecteur.
*)
*( DESCRIPTION
*=
*)
d*/
void PrmIo::EcrisVecteurChaines(const char*  nom_vecteur,
                                const MyString  vecteur[],
                                const int    nb_elements)
{
    int i;

    DECL_OUT_FILE;
    fichier << char(CT_START) << " " << nom_vecteur << endl;
    ind_ligne++;

    for (i = 0; i < nb_elements; i++)
    {
        if (vecteur[i].length() == 0)
        {
            fichier << "?";
        }
        else
        {
            fichier << vecteur[i].c_str();
        }
        fichier << endl;
        ind_ligne++;
    }

    fichier << char(CT_END) << endl;
    ind_ligne++;

}


/*D
*=
*( ROLE
*=
** Ecrit un vecteur de re'els.
*)
*( INTERFACE
*=
*+ nom_vecteur : entre'e
** Nom du vecteur.
**
*+ vecteur, nb_elements : entre'e
** Vecteur.
*)
*( DESCRIPTION
*=
*)
d*/
void PrmIo::EcrisVecteurReels(const char* nom_vecteur,
                              const float vecteur[],
                              const int   nb_elements,
                              const int precision)
{
    int i;
    DECL_OUT_FILE;

    fichier << char(CT_START) << " " << nom_vecteur << endl;
    ind_ligne++;

    for (i = 0; i < nb_elements; i++)
    {
        if (vecteur[i] == undefined_float)
        {
            fichier << "?";
        }
        else
        {
            fichier.setprecision(precision);
            fichier << vecteur[i];
        }
        fichier << endl;
        ind_ligne++;
    }

    fichier << char(CT_END) << endl;
    ind_ligne++;

}
#endif






void PrmIo::destroy_handler()
{
  if (m_handler_owned_by_this)
    {
      LOGGED_DELETE(m_handler);
    }
}

void PrmIo::indent()
{
  DECL_OUT_FILE;

  for (int i = 0; i < m_current_indent; i++)
    {
      fichier << ' ';
    }
}


MyString PrmIo::read_filename(const char *ident_name,
			      const bool undefined_allowed,
			      const char *default_value)
{
  return read_string(ident_name,undefined_allowed,default_value).eval_env_variables();
}


void PrmIo::store_position()
{
  m_stored_position = get_input_stream().tellg();
  m_stored_line_number = ind_ligne;
  if (m_has_cached_char)
    {
      // cached char: will be lost on restore, so decrease position
      m_stored_position--;
    }

}

void PrmIo::restore_position()
{
  my_assert (m_stored_position != -1);

  get_input_stream().seekg(m_stored_position,sd_beg);
  ind_ligne = m_stored_line_number;
  // ignore cached char, would be irrelevant
  m_has_cached_char = false;
}

void PrmIo::read(const char *list_name,
		 std::list<MyString> &lst,
		 const int nb_required_elements,
		 bool undefined_allowed)
{
  ENTRYPOINT(read<list<MyString> >);
  Mot  mot_lu;
  Mot nom_bloc;

  lst.clear();

  if (!check_delimitor(CT_START))
    {
      abort_run("initial block delimiter error%s "
		"(while reading list %q)",
		get_file_and_line(), list_name);

    }

  read_word(nom_bloc,list_name);

  if (strcasecmp(nom_bloc, list_name) != 0)
    {
      // bad block name
      abort_run("%q read instead of %q%s",
		nom_bloc, list_name,  get_file_and_line());

    }


  // read any number of elements

  bool end_delim_found;
  int nb_elements = 0;
  do
    {
      end_delim_found = read_word(mot_lu,list_name == 0 ?
				  "a string list" : list_name,false,
				  true /* allow end delim */);
      nb_elements++;

      if (COMPARE_TO_UNDEFINED(mot_lu) == 0)
	{
	  if (!undefined_allowed)
	    {
	      abort_run("Item #%d should not be undefined%s",
			nb_elements,get_file_and_line());
	    }
	}

      if (!end_delim_found)
	{
	  lst.push_back(mot_lu);
	}

    }
    while (!end_delim_found);
  // no need to check for end delimitor

  nb_elements--; // minus the end delimitor

  if ((nb_required_elements != undefined_integer)
      && (nb_required_elements != nb_elements))
    {
      abort_run("found %d items in list %q, %d items expected%s",
		nb_elements,list_name,nb_required_elements,
		get_file_and_line());

    }



  EXITPOINT;
}
PrmIo &PrmIo::operator<<(const char *in)
{
  DECL_OUT_FILE;
  fichier << in;
  return *this;
}
PrmIo &PrmIo::operator<<(const float in)
{
  DECL_OUT_FILE;
  fichier << in;
  return *this;
}
PrmIo &PrmIo::operator<<(const int in)
{
  DECL_OUT_FILE;
  fichier << in;
  return *this;
}

PrmIo &PrmIo::operator>>(float &out)
{
  Mot wrd;
  read_word(wrd,"float");
  decode_scalar(out,wrd,false);

  return *this;
}

PrmIo &PrmIo::operator>>(int &out)
{
  Mot wrd;
  read_word(wrd,"int");
  decode_scalar(out,wrd,false);

  return *this;
}
